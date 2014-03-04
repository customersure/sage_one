require 'typhoeus'
require 'typhoeus/adapters/faraday'
require 'faraday_middleware'
require 'faraday/request/oauth2'
require 'faraday/response/raise_sage_one_exception'
require 'faraday/response/convert_sdata_to_headers'

module SageOne
  # @api private
  # @note Used by request.rb to make Faraday requests to the SageOne API.
  module Connection
    private

    # @return [Faraday::Connection] configured with the headers SageOne expects
    #   and our required middleware stack. raw_response can be set to true to
    #   help with debugging.
    def connection
      options = {
        headers:  { 'Accept'        => "application/json; charset=utf-8",
                    'User-Agent'    => user_agent,
                    'Content-Type'  => 'application/json' },
        proxy:    proxy,
        ssl:      { verify: false },
        url:      api_endpoint
      }

      Faraday.new(options) do |conn|
        conn.adapter :typhoeus
        conn.request :json

        conn.use FaradayMiddleware::OAuth2, access_token
        conn.use FaradayMiddleware::RaiseSageOneException

        unless raw_response
          conn.use FaradayMiddleware::Mashify
          conn.use FaradayMiddleware::ConvertSdataToHeaders
          conn.use FaradayMiddleware::ParseJson
        end

        conn.use FaradayMiddleware::FollowRedirects, limit: 1

        faraday_config_block.call(conn) if faraday_config_block

        conn.adapter(adapter)
      end
    end
  end

end
