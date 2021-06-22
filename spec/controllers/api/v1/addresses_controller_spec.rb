require 'rails_helper'

RSpec.describe Api::V1::AddressesController, type: :controller do
  subject(:address) { create(:address_sp) } 

  login_api_token
  render_views

  describe 'GET #index' do
    before { create_list(:address, 22) }

    let(:expected_data) do
      [ id: (be_kind_of Numeric),
        city: (be_kind_of String),
        neighborhood: (be_kind_of String),
        state: (be_kind_of String),
        street: (be_kind_of String),
        postal_code: /\d/,
        user: 'Rodrigo',
        url: 'http://test.host/api/v1/addresses/1' ]
    end

    it 'loads the collection' do
      get :index, format: :json

      parsed_response = response.body.parse_from_json
      expect(parsed_response.fetch('data')).to include_json expected_data
    end

    it 'returns twenty registers to page one' do
      get :index, format: :json

      parsed_response = response.body.parse_from_json
      expect(parsed_response.fetch('data').length).to eq(20)
    end

    it 'returns two registers to page two' do
      get :index, params: { page: 2 }, format: :json

      parsed_response = response.body.parse_from_json
      expect(parsed_response.fetch('data').length).to eq(2)
    end

    it 'request is 200 Ok' do
      get :index, format: :json

      expect(response).to have_http_status :ok
    end

    it 'returns request 406 Not Acceptable if accept in header is empty' do
      request.accept = nil
      get :index, format: :json

      expect(response).to have_http_status :not_acceptable
    end
  end

  describe 'GET #show' do
    let(:expected_data) do
      { id: address.id, city: 'São Paulo', neighborhood: 'Sé', state: 'SP', street: 'Praça da Sé - lado ímpar',
        postal_code: '01001000', user: 'Rodrigo', url: "http://test.host/api/v1/addresses/#{address.id}" }
    end

    it 'loads the resource' do
      get :show, params: { id: address.id }, format: :json

      parsed_response = response.body.parse_from_json
      expect(parsed_response.fetch('data')).to include_json expected_data
    end

    it 'request is 200 Ok' do
      get :show, params: { id: address.id }, format: :json

      expect(response).to have_http_status :ok
    end

    it 'returns request 406 Not Acceptable if accept in header is empty' do
      request.accept = nil
      get :show, params: { id: address.id }, format: :json

      expect(response).to have_http_status :not_acceptable
    end
  end

  describe 'POST #create' do
    WebMock.allow_net_connect!

    before do
      stub_request(:post, 'https://ws.apicep.com/cep/13606062.json')
        .to_return(status: 201, body: { data: expected_data }.to_json)
    end

    let(:expected_data) do
      { id: 1, city: 'São Paulo', neighborhood: 'Sé', state: 'SP', street: 'Praça da Sé - lado ímpar',
        postal_code: '01001000', user: 'Rodrigo', url: 'http://test.host/api/v1/addresses/1' }
    end

    it 'creates a address with valid postal_code' do
      expect { post :create, params: { postal_code: 13606062 }, format: :json }.to \
        change(Address, :count).from(0).to(1)
    end

    it 'returns error with postal_code not found' do
      post :create, params: { postal_code: 999 }, format: :json

      parsed_response = response.body.parse_from_json
      expect(parsed_response).to include_json(errors: { base: ['CEP não encontrado']})
    end

    it 'returns error with blank postal_code' do
      post :create, params: { postal_code: nil }, format: :json

      parsed_response = response.body.parse_from_json
      expect(parsed_response).to include_json(errors: 'param is missing or the value is empty: postal_code')
    end

    it 'returns error without postal_code' do
      post :create, format: :json

      parsed_response = response.body.parse_from_json
      expect(parsed_response).to include_json(errors: 'param is missing or the value is empty: postal_code')
    end

    it 'request is 201 created' do
      post :create, params: { postal_code: 13606062 }, format: :json

      expect(response).to have_http_status :created
    end

    it 'returns request 406 Not Acceptable if accept in header is empty' do
      request.accept = nil
      post :create, params: { postal_code: 13606062 }, format: :json

      expect(response).to have_http_status :not_acceptable
    end
  end

  describe 'PATCH #update' do
    before { address }

    it 'update the street value' do
      patch :update, params: { id: address.id, data: { street: 'Rua logo ali' } }, format: :json

      parsed_response = response.body.parse_from_json
      expect(address.reload.street).to eq 'Rua logo ali'
    end

    it 'does not update the postal code value' do
      patch :update, params: { id: address.id, data: { postal_code: '007' } }, format: :json

      parsed_response = response.body.parse_from_json
      expect(address.reload.postal_code).not_to eq '007'
    end

    it 'request is 200 Ok' do
      delete :destroy, params: { id: address.id }, format: 'json'

      expect(response).to have_http_status :ok
    end

    it 'returns request 406 Not Acceptable if accept in header is empty' do
      request.accept = nil
      delete :destroy, params: { id: address.id }, format: 'json'

      expect(response).to have_http_status :not_acceptable
    end
  end

  describe 'DELETE #destroy' do
    before { address }

    it 'delete an resource' do
      expect { delete :destroy, params: { id: address.id }, format: 'json' }.to \
        change(Address, :count).from(1).to(0)
    end

    it 'request is 200 Ok' do
      delete :destroy, params: { id: address.id }, format: 'json'

      expect(response).to have_http_status :ok
    end

    it 'returns request 406 Not Acceptable if accept in header is empty' do
      request.accept = nil
      delete :destroy, params: { id: address.id }, format: 'json'

      expect(response).to have_http_status :not_acceptable
    end
  end
end