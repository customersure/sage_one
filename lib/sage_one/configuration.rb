require 'faraday'
require 'sage_one/version'

module SageOne
  module Configuration
    VALID_OPTIONS_KEYS = [
      :adapter,
      :faraday_config_block,
      :api_endpoint,
      :proxy,
      :access_token,
      :client_id,
      :client_secret,
      :user_agent,
      :request_host,
      :auto_traversal,
      :raw_response].freeze

    DEFAULT_ADAPTER        = Faraday.default_adapter
    DEFAULT_API_VERSION    = 1
    DEFAULT_API_ENDPOINT   = 'https://app.sageone.com/api/v1/'.freeze
    DEFAULT_USER_AGENT     = "SageOne Ruby Gem #{SageOne::VERSION}".freeze
    DEFAULT_AUTO_TRAVERSAL = false
    DEFAULT_RAW_RESPONSE   = false

    attr_accessor(*VALID_OPTIONS_KEYS)

    def api_endpoint=(value)
      @api_endpoint = File.join(value, "")
    end

    def faraday_config(&block)
      @faraday_config_block = block
    end

    def configure
      yield self
    end

    def options
      VALID_OPTIONS_KEYS.inject({}){|o,k| o.merge!(k => send(k)) }
    end

    def self.extended(base)
      base.reset
    end

    def reset
      self.adapter        = DEFAULT_ADAPTER
      self.api_endpoint   = DEFAULT_API_ENDPOINT
      self.proxy          = nil
      self.access_token   = nil
      self.client_id      = nil
      self.client_secret  = nil
      self.request_host   = nil
      self.user_agent     = DEFAULT_USER_AGENT
      self.auto_traversal = DEFAULT_AUTO_TRAVERSAL
      self.raw_response   = DEFAULT_RAW_RESPONSE
    end
  end
end
