class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, inverse_of: :user, dependent: :restrict_with_error

  validates :name, presence: true
  validates :api_token, uniqueness: true
end
