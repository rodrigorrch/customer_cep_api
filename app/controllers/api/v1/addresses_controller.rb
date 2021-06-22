module Api
  module V1
    class AddressesController < ApplicationController
      before_action :load_resource, only: %i[show update destroy]

      rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
      rescue_from ActionController::ParameterMissing, with: :parameter_missing

      def index
        @resource_collection = load_resource_collection.order(:id).page(params[:page] || 1).per(20)

        respond_to { |format| format.json { render :index } }
      end

      def show
        respond_to { |format| format.json { render :show } }
      end

      def create
        postal_code = params.require(:postal_code)
        @resource = resource_class.search_address_by_postal_code(postal_code)

        if resource.errors.blank? && resource.save
          respond_to { |format| format.json { render :show, status: :created } }
        else
          render json: { errors: resource.errors }, status: :unprocessable_entity
        end
      end

      def update
        @resource.update(permitted_params)

        respond_to { |format| format.json { render :show } }
      end

      def destroy
        return head :unprocessable_entity unless @resource.destroy

        head :ok
      end

      private

      def permitted_params
        return {} unless params[:data]

        params.require(:data)
              .permit(%i[city neighborhood state street]).to_h
              .compact.deep_symbolize_keys
      end

      def record_invalid
        render json: { errors: rresource.errors }, status: :unprocessable_entity
      end

      def parameter_missing(error)
        render json: { errors: error.message.try(:split, "\n").try(:first) }, status: :unprocessable_entity
      end

      def standard_error(error)
        render json: { errors: 'Internal Server Error' }, status: :internal_server_error
      end
    end
  end
end
