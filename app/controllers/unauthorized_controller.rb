class UnauthorizedController < ActionController::API
  def index
    head :unauthorized
  end
end
