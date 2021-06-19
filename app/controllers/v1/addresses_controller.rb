module V1
  class AddressesController < ApplicationController
    # respond_to :json

    def index
      render json: { teste: 'lala' }
    end
  end
end
