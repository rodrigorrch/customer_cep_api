require 'rails_helper'

RSpec.describe Request::PostalCodeService, type: :service do
  WebMock.allow_net_connect!

  let(:api_url) { 'https://ws.apicep.com/cep/' }
  let(:url) { "#{api_url}#{postal_code}.json" }

  before { ENV['API_URL'] = api_url }

  context 'with valid data' do
    let(:postal_code) { '13606062' }
    let(:body) do
      { status: 200,
        ok: true,
        code: '13606-062',
        state: 'SP',
        city: 'Araras',
        district: 'Sítios de Recreio Independência',
        address: 'Avenida Carola',
        statusText: 'ok' }
    end

    before do
      stub_request(:get, url)
        .to_return({ status: 200, body: body.to_json })
    end

    it 'returns json api' do
      data_api = described_class.call(postal_code).attributes.as_json

      expect(data_api).to include_json(
        end_point: 'https://ws.apicep.com/cep/13606062.json', errors:{}, status: 200, ok: true, statusText: 'ok',
        code: '13606-062', state: 'SP', city: 'Araras', district: 'Sítios de Recreio Independência', address: 'Avenida Carola',
      )
    end
  end

  context 'with invalid data' do
    let(:postal_code) { '999' }
    let(:body) do
      { status: 400,
        ok: false,
        message: 'CEP informado é inválido',
        statusText: 'bad_request' }
    end

    before do
      stub_request(:get, url)
        .to_return({ status: 200, body: body.to_json })
    end

    it 'returns json api' do
      data_api = described_class.call(postal_code).base.attributes.as_json
      expect(data_api).to include_json(
        end_point: 'https://ws.apicep.com/cep/999.json', errors: { :base=>['CEP informado é inválido']},
        status: 400, ok: false,message: 'CEP informado é inválido', statusText: 'bad_request'
      )
    end
  end
end
