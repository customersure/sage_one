require 'sage_one/connection'
require 'sage_one/request'

module SageOne

  # This module helps with setting up the OAuth connection to SageOne. After the two
  # step process you will have an access_token that you can store and use
  # for making future API calls.
  #
  # @see OAuth#authorize_url Step 1 - Authorization request
  # @see #get_access_token Step 2 - Access Token Request

  module OAuth

    # Generates the OAuth URL for redirecting users to SageOne. You should ensure
    # the your SageOne.client_id is configured before calling this method.
    #
    # @param [String] callback_url SageOne OAuth will pass an authorization code back to this URL.
    # @return [String] The URL for you to redirect the user to SageOne.
    # @example
    #   SageOne.authorize_url('https://example.com/auth/sageone/callback')
    def authorize_url(callback_url)
      params = {
        client_id:     client_id,
        redirect_uri:  callback_url,
        response_type: 'code'
      }

      options = retrieve_request_options(authorization_url_prefix, content_type)
      connection(options).build_url(authorization_url_postfix, params).to_s
    end

    # Returns an access token for future authentication.
    #
    # @param [String] code The authorization code SageOne sent to your callback_url.
    # @param [String] callback_url The callback URL you used to get the authorization code.
    # @return [Hashie::Mash] Containing the access_token, refresh_token for you to store for making future API calls.
    # @example
    #   # Assuming (Rails) your code is stored in params hash.
    #   SageOne.get_access_token(params[:code], 'https://example.com/auth/sageone/callback')
    def get_access_token(code, callback_url)
      params = {
        client_id:      client_id,
        client_secret:  client_secret,
        grant_type:     'authorization_code',
        code:           code,
        redirect_uri:   callback_url
      }

      options = retrieve_request_options(token_url_prefix, token_content_type)
      response = connection(options).post do |request|
        request.path = token_url_postfix
        request.body = URI.encode_www_form(params)
      end

      raw_response ? response : response.body
    end

    # Returns an access token for future authentication.
    #
    # @param [String] code The refresh_token SageOne returned while getting access_token.
    # @return [Hashie::Mash] Containing the access_token, refresh_token for you to store for making future API calls.
    # @example
    #   SageOne.renew_access_token('123123123')
    def renew_access_token(refresh_token)
      params = {
        client_id:     client_id,
        client_secret: client_secret,
        grant_type:    'refresh_token',
        refresh_token: refresh_token
      }

      options = retrieve_request_options(token_url_prefix, token_content_type)
      response = connection(options).post do |request|
        request.path = token_url_postfix
        request.body = URI.encode_www_form(params)
      end

      raw_response ? response : response.body
    end

    def revoke_refresh_token(refresh_token)
      params = {
        client_id:     client_id,
        client_secret: client_secret,
        token: refresh_token
      }

      options = retrieve_request_options(token_url_prefix, token_content_type)
      response = connection(options).post do |request|
        request.path = revoke_token_url_postfix
        request.body = URI.encode_www_form(params)
      end

      raw_response ? response : response.body
    end
  end
end
