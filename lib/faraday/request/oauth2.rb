require 'faraday'

# @api private
module FaradayMiddleware

  AUTH_HEADER = 'Authorization'.freeze

  # Simple middleware that adds the access token to each request.
  #
  # The access token is placed in the "Authorization" HTTP request header.
  # However, an explicit "Authorization" header for the current request
  # will not be overriden.
  # @api private
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
