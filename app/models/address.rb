class Address < ApplicationRecord
  validates :postal_code, :user, presence: true

  belongs_to :user, inverse_of: :addresses

  before_create :load_user

  private

  def load_user
    self.user = CurrentSession.user.presence || current_user
  end
end
