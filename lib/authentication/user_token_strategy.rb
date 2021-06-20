require 'warden'

module Authentication
  class UserTokenStrategy < Warden::Strategies::Base
    def valid?
      api_token.present?
    end

    def authenticate!
      user = User.find_by(api_token: api_token)

      if user.present? && validate_token(user)
        CurrentSession.user = user

        success! user  
      else
        fail!('Login não autorizado ou token inválido')
      end
    end

    private

    def api_token
      @api_token ||= request.get_header('HTTP_AUTHORIZATION').to_s.remove('Bearer ')
    end

    def validate_token(user)
      ActiveSupport::SecurityUtils.secure_compare(api_token, user.api_token)
    end
  end
end
