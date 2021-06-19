class ApplicationController < ActionController::API
  include AuthenticatedController

  respond_to :json

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
