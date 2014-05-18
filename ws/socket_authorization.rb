class SocketAuthorization
  def initialize(request)
    @request = request
  end

  def authorized?
    valid_path? && user_authorized?
  end

  def valid_path?
    !!user_id
  end

  def user_id
    return @user_id if defined(@user_id)
    match = @request.path.match(%r{^/users/(\d+)$})
    @user_id = if match
      match[1]
    end
  end

  def user_authorized?
    user.authorized?(access_token) if access_token
  end

  def access_token
    @request.query["access_token"] if user
  end

  def user
    @user ||= User.find_by(id: user_id)
  end
end
