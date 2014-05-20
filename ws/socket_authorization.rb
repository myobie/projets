require 'em-http-request'

class SocketAuthorization
  attr_reader :answer

  def initialize(request)
    @request = request
  end

  def authorized?
    if user_id? && access_token?
      authorize_user!
    else
      error!
    end
  end

  def user_id?
    !!user_id
  end

  def user_id
    return @user_id if defined(@user_id)
    match = @request.path.match(%r{^/users/(\d+)$})
    @user_id = if match
      match[1]
    end
  end

  def access_token
    @request.query["access_token"]
  end

  def access_token?
    !!access_token
  end

  def finished?
    defined?(@answer)
  end

  def errback(&blk)
    @errback = blk
    blk.call(answer) if finished?
  end

  def callback(&blk)
    @callback = blk
    blk.call(answer) if finished?
  end

  def authorize_user!
    opts = {
      head: {
        "X-Access-Token" => access_token
      },
      path: "/people/#{user_id}"
    }

    host = ENV.fetch("HOST_TO_PROXY")
    http = EM::HttpRequest.new("https://#{host}/")
    http.setup_request(:get, opts)

    http.errback { error! }
    http.callback do
      if http.response_header.status == "200"
        json = JSON.parse(http.response)
        success! json
      else
        error!
      end
    end

    self
  end

  def success!(new_answer)
    @answer = new_answer
    @callback.call(answer) if @callback
  end

  def error!(new_answer = nil)
    @answer = new_answer
    @errback.call(answer) if @errback
  end
end
