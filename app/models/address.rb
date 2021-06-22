class Address < ApplicationRecord
  validates :postal_code, :user, presence: true

  belongs_to :user, inverse_of: :addresses

  before_validation :load_user
  before_validation :format_postal_code

  delegate :name, to: :user, allow_nil: true, prefix: true

  def self.search_address_by_postal_code(postal_code)
    return if postal_code.blank?

    postal_code = postal_code.to_s.only_numbers.rjust(8, '0')
    api_data = Request::PostalCodeService.call(postal_code)

    initialize_address(api_data, postal_code)
  end

  private

  def load_user
    self.user ||= CurrentSession.user.presence
  end

  def format_postal_code
    self.postal_code = postal_code.to_s.only_numbers.rjust(8, '0')
  end

  def self.initialize_address(data, postal_code)
    find_or_initialize_by(postal_code: postal_code).tap do |address|
      if data.is_a? ActiveModel::Error
        address.errors.add(:base, data.message)
        return address
      end

      address.assign_attributes(
        city: data.city, neighborhood: data.district, state: data.state, street: data.address
      )
    end
  end
end
