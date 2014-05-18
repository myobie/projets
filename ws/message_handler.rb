require 'em-http-request'

class MessageHandler
  def self.call(authorization, socket, message)
    new(socket, message).call
  end

  def initialize(authorization, socket, message)
    @authorization = authorization
    @socket = socket
    @message = message
  end

  def call
    if message_json?
      case message_type
      when "request"
        http_request
      else
        write(unkown_message_type_response)
      end
    else
      write(parse_error_repsonse)
    end
  end

  def http_request
    request_id = message_json["request_id"]

    host = ENV.fetch("HOST_TO_PROXY")
    verb = message_json["verb"]
    path = message_json["path"]
    body = message_json["body"]
    query = message_json["query"]
    headers = message_json["headers"]
    headers["X-Request-ID"] ||= request_id
    headers["X-Access-Token"] ||= authorization.access_token

    opts = {
      head: headers,
      body: body,
      path: path,
      query: query
    }

    http = EM::HttpRequest.new("https://#{host}/")
    http.setup_request(verb.intern, opts)

    http.errback do
      write({
        type: "request_error",
        request_id: request_id
      })
    end

    http.callback do
      write({
        type: "response",
        request_id: request_id,
        code: http.response_header.status,
        body: http.response
      })
    end
  end

  def message_json
    return @json if defined?(@json)
    @json = JSON.parse(@message)
  rescue JSON::ParseError
    @json = nil
  end

  def message_json?
    !!message_json
  end

  def message_type
    message_json["type"]
  end

  def error_esponse(type, message)
    {
      type: "error",
      error: {
        type: type,
        code: 422,
        message: message,
        body: @message
      }
    }
  end

  def parse_error_repsonse
    error_response "parse_error", "Could not parse provided json"
  end

  def unkown_message_type_response
    error_response "unkown_message_type", "Unknown message type #{message_type}"
  end
end
