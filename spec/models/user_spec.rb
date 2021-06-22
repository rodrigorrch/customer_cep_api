require 'rails_helper'

RSpec.describe User, type: :model do
  context 'when defining the model' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :password }
    it { is_expected.to have_many(:addresses) }
    it { is_expected.to validate_uniqueness_of :api_token }
  end
end
