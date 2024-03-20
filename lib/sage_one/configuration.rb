require 'faraday'
require 'sage_one/version'

module SageOne
  # Provide numerous configuration options that control core behaviour.
  module Configuration
    VALID_OPTIONS_KEYS = %i[
      adapter
      faraday_config_block
      api_endpoint
      authorization_url_prefix
      authorization_url_postfix
      token_url_prefix
      token_url_postfix
      revoke_token_url_postfix
      content_type
      token_content_type
      proxy
      access_token
      business_id
      client_id
      client_secret
      user_agent
      request_host
      auto_traversal
      raw_response
    ].freeze

    DEFAULT_ADAPTER                = Faraday.default_adapter
    DEFAULT_API_ENDPOINT           = 'https://api.accounting.sage.com/v3.1'.freeze
    DEFAULT_AUTHORIZATION_URL_PREFIX  = 'https://www.sageone.com'.freeze
    DEFAULT_AUTHORIZATION_URL_POSTFIX = 'oauth2/auth/central'.freeze

    DEFAULT_TOKEN_URL_PREFIX  = 'https://oauth.accounting.sage.com'.freeze
    DEFAULT_TOKEN_URL_POSTFIX = 'token'.freeze
    DEFAULT_REVOKE_TOKEN_URL_POSTFIX = 'revoke'.freeze

    DEFAULT_CONTENT_TYPE       = 'application/json'.freeze
    DEFAULT_TOKEN_CONTENT_TYPE = 'application/x-www-form-urlencoded'.freeze

    DEFAULT_USER_AGENT         = "SageOne Ruby Gem #{SageOne::VERSION}".freeze

    # Only get the first page when making paginated data requests
    DEFAULT_AUTO_TRAVERSAL = false

    # Parse Json, Mashify & convert SData when making requests
    DEFAULT_RAW_RESPONSE   = false

    attr_accessor(*VALID_OPTIONS_KEYS)

    # Override the default API endpoint, this ensures a trailing forward slash is added.
    # @param [String] value for a different API endpoint
    # @example
    #   SageOne.api_end_point = 'https://app.sageone.com/api/v2/'
    def api_endpoint=(value)
      @api_endpoint = File.join(value, "")
    end

    # Stores the given block which is called when the new Faraday::Connection
    # is set up for all requests. This allow you to configure the connection,
    # for example with your own middleware.
    def faraday_config(&block)
      @faraday_config_block = block
    end

    # Yields the given block passing in selfing allow you to set config options
    # on the 'extend'-ing module.
    # @example
    #   SageOne.configure do |config|
    #     config.access_token = 'my-access-token'
    #   end
    def configure
      yield self
    end

    # @return [Hash] All options with their current values
    def options
      VALID_OPTIONS_KEYS.inject({}){|o,k| o.merge!(k => send(k)) }
    end

    # When extended call reset
    def self.extended(base)
      base.reset
    end

    # Sets the options to the default values
    def reset
      self.adapter        = DEFAULT_ADAPTER
      self.proxy          = nil
      self.access_token   = nil
      self.client_id      = nil
      self.client_secret  = nil
      self.business_id    = nil
      self.request_host   = nil
      self.user_agent     = DEFAULT_USER_AGENT
      self.auto_traversal = DEFAULT_AUTO_TRAVERSAL
      self.raw_response   = DEFAULT_RAW_RESPONSE
      self.api_endpoint   = DEFAULT_API_ENDPOINT

      reset_authentication_urls
      reset_content_types
    end

    def reset_authentication_urls
      self.authorization_url_prefix  = DEFAULT_AUTHORIZATION_URL_PREFIX
      self.authorization_url_postfix = DEFAULT_AUTHORIZATION_URL_POSTFIX
      self.token_url_prefix          = DEFAULT_TOKEN_URL_PREFIX
      self.token_url_postfix         = DEFAULT_TOKEN_URL_POSTFIX
      self.revoke_token_url_postfix  = DEFAULT_REVOKE_TOKEN_URL_POSTFIX
    end

    def reset_content_types
      self.content_type       = DEFAULT_CONTENT_TYPE
      self.token_content_type = DEFAULT_TOKEN_CONTENT_TYPE
    end
  end
end
