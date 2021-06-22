module Request
  class PostalCodeService < ApplicationService
    require 'httparty'

    include ActiveModel::Serializers::JSON

    PARAMS = %i[status ok code state city district address statusText message].freeze

    attr_reader :end_point
    attr_accessor *PARAMS

    def initialize(postal_code)
      @end_point = URI("#{api_url}#{postal_code}.json")
      @errors = ActiveModel::Errors.new(self)
    end

    def call
      response = HTTParty.get(end_point, headers: { 'Accept' => 'application/json' })
      result = from_json(response.body)

      return @errors.add(:base, result.message) if result.try(:message).present?

      result
    rescue HTTParty::Error => error
      @errors.add(:base, error.message)
    end

    def attributes
      instance_values
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
