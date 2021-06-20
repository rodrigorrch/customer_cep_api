module CepLa
  class PostalCodeService < ApplicationService
    require 'httparty'

    include ActiveModel::Serializers::JSON

    PARAMS = %i[cep uf cidade bairro logradouro].freeze

    attr_reader :end_point
    attr_accessor *PARAMS

    def initialize(postal_code)
      @end_point = URI("#{api_url}#{postal_code}")
    end

    def call
      response = HTTParty.get(end_point, headers: { 'Accept' => 'application/json' })
      result = from_json(response.body)
    rescue HTTParty::Error => error
      { success?: false, error: error }
    else
      { success?: true, payload: result }
    end

    private

    def attributes=(hash)
      hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def api_url
      ENV['API_URL']
    end
  end
end
