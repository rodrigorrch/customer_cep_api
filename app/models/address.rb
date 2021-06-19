class Address < ApplicationRecord
  validates :postal_code, :user, presence: true

  belongs_to :user, inverse_of: :addresses
end
