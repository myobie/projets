class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from   ActiveRecord::RecordNotFound, with: :render_not_found_error

  respond_to    :json
  before_filter :require_authentication

  private

  def render_not_found_error
    render_error "not found", status: 404
  end

  def render_unauthenticated_error
    render_error "You are not authenticated", status: 401
  end

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

  def current_user_id
    current_user && current_user.id
  end
  helper_method :current_user_id

  def current_access_token
    return @current_access_token if defined?(@current_access_token)
    token = request.headers["X-Access-Token"] || params[:access_token] || current_access_token_cookie
    @current_access_token = AccessToken.find_by_token_header(token)
  end
  helper_method :current_access_token

  def current_access_token_cookie
    cookies.permanent.signed[:access_token]
  end
  helper_method :current_access_token_cookie

  def authenticated?
    !!current_user
  end

  def require_authentication
    unless authenticated?
      render_unauthenticated_error
    end
  end
end
