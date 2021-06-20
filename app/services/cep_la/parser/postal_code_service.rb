module CepLa
  module Parser
    class PostalCodeService < ApplicationService
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def call
        address = Address.find_or_initialize_by(postal_code: data.cep).tap do |attribute|
          attribute.city          = data.cidade
          attribute.neighborhood  = data.bairro
          attribute.state         = data.uf
          attribute.street        = data.logradouro
          attribute.user          = CurrentSession.user.presence || current_user
        end

        address.valid?
        address
      end
    end
  end
end
