module AuthenticatedController
  extend ActiveSupport::Concern

  included do
    before_action :authenticate!
  end

  private

  def authenticate!
    request.env['warden'].authenticate!
  end

  def current_logged
    request.env['warden'].user
  end
end
