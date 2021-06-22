class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include AuthenticatedController
  include ResourceHelpers

  before_action :ensure_json_request

  respond_to :json

  private

  def ensure_json_request
    return if request.headers['Accept'] =~ /json/
    render body: nil, status: 406
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
