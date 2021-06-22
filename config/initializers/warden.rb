Rails.application.reloader.to_prepare do
  Warden::Strategies.add(:api_token, Authentication::UserTokenStrategy)
end
