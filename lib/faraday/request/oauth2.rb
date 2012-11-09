require 'faraday'

module FaradayMiddleware

  # Public: Simple middleware that adds the access token to each request.
  #
  # The access token is placed in the "Authorization" HTTP request header.
  # However, an explicit "Authorization" header for the current request
  # will not be overriden.
  #
  # Examples
  #
  #   # configure access token:
  #   OAuth2.new(app, 'abc123')
  AUTH_HEADER = 'Authorization'.freeze

  class OAuth2 < Faraday::Middleware
    def call(env)
      env[:request_headers][AUTH_HEADER] ||= %(Bearer #{@token}) if @token
      @app.call env
    end

    def initialize(app, token = nil)
      super(app)
      @token = token
    end
  end
end
