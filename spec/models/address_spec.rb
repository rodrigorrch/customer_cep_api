require 'rails_helper'

RSpec.describe Address, type: :model do
  subject(:address_sp) { create(:address_sp) } 

  context 'when defining the model' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to validate_presence_of :user }
  end

  context 'when before_validation' do
    allow_current_session_user

    describe '.load_user' do
      let(:address) { build(:address_sp, user: nil) }

      it 'loads the user' do
        address.save

        expect(address.user_name).to eq('Rodrigo')
      end
    end

    describe '.format_postal_code' do
      it 'loads the postal_code formatted with only numbers' do
        address = build(:address_sp, postal_code: 'abc13606062abc')
        address.save

        expect(address.postal_code).to eq('13606062')
      end

      it 'loads the postal_code formatted with rjust zeros' do
        address = build(:address_sp, postal_code: '1')
        address.save

        expect(address.postal_code).to eq('00000001')
      end
    end
  end

  context 'with class object' do
    WebMock.allow_net_connect!

    let(:address_by_postal_code) { described_class.search_address_by_postal_code('13600001') }

    describe '.search_address_by_postal_code' do
      it "retuns a address" do
        expect(address_by_postal_code).to be_a Address
      end

      it "retuns an address hash" do
        expect(address_by_postal_code.attributes).to include_json(
          city: 'Araras', neighborhood: 'Centro', state: 'SP', street: 'Avenida Dona Renata', postal_code: '13600001'
        )
      end
    end
  end
end
