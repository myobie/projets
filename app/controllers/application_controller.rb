class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  respond_to    :json
  before_filter :require_authentication

  private

  def render_error(message, status: 400)
    render_json({ type: "error", message: message }, status: status)
  end

  def render_json(object, status: 200)
    render json: JSON.generate(object), status: status
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = if current_access_token
      current_access_token.user
    end
  end

  def current_access_token
    return @current_access_token if defined?(@current_access_token)
    token = request.headers["X-Access-Token"]
    @current_access_token = AccessToken.find_by_token_header(token)
  end

  def authenticated?
    !!current_user
  end

  def require_authentication
    unless authenticated?
      render json: { type: "error", message: "You are not authenticated" }, status: 401
    end
  end
end
