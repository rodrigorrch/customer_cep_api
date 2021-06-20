class UnauthorizedController < ActionController::API
  respond_to :json

  def index
    head :unauthorized
  end
end
