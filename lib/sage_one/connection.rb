require 'faraday_middleware'
require 'faraday/request/oauth2'
require 'faraday/response/raise_sage_one_exception'

module SageOne
  # @private
  module Connection
    private

    def connection(raw=false)
      options = {
        headers:  { 'Accept'        => "application/json; charset=utf-8",
                    'User-Agent'    => user_agent,
                    'Content-Type'  => 'application/json' },
        proxy:    proxy,
        ssl:      { verify: false },
        url:      api_endpoint
      }

      Faraday.new(options) do |conn|
        conn.request :json

        conn.use FaradayMiddleware::OAuth2, access_token
        conn.use FaradayMiddleware::RaiseSageOneException

        unless raw
          conn.use FaradayMiddleware::Mashify
          conn.use FaradayMiddleware::ParseJson
        end

        faraday_config_block.call(conn) if faraday_config_block

        conn.adapter(adapter)
      end
    end
  end

end
