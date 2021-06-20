module V1
  class AddressesController < ApplicationController
    before_action :load_resource, only: %i[show update destroy]

    def index
      @resource_collection = load_resource_collection.page(params[:page] || 1)

      respond_to { |format| format.json { render :index } }
    end

    def show
      respond_to { |format| format.json { render :show } }
    end

    def create
      if api_data[:success?] && resource_class_parsed.save

        @resource = resource_class_parsed
        respond_to { |format| format.json { render :show } }
      else
        render json: { errors: api_data[:error].presence || resource_class_parsed.errors }, status: :unprocessable_entity
      end
    rescue ActionController::ParameterMissing => error
      render json: { errors: error.message }, status: :unprocessable_entity
    end

    def destroy
      return head :unprocessable_entity unless @resource.destroy

      head :ok
    end

    private

    def resource_class_parsed
      CepLa::Parser::PostalCodeService.call(api_data[:payload])
    end

    def api_data
      @api_data ||= CepLa::PostalCodeService.call(params[:postal_code])
    end
  end
end
