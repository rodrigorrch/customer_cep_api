module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryBot.create(:user)
      sign_in user
    end
  end

  def login_api_token
    let(:api_user) { FactoryBot.create(:user) }
    let(:api_token) { api_user.api_token }

    before do
      authentication_header = {
        'Accept' => 'application/vnd.api+json',
        'Authorization' => "Bearer #{api_token}"
      }

      request.headers.merge!(authentication_header)
    end
  end
end
