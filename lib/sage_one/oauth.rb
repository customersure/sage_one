require 'sage_one/connection'
require 'sage_one/request'

module SageOne

  module OAuth

    # Return URL for OAuth authorization
    def authorize_url(redirect_uri)
      params = {
        client_id:      client_id,
        redirect_uri:   redirect_uri,
        response_type: 'code'
      }
      connection.build_url("/oauth/authorize/", params).to_s
    end

    # Return an access token from authorization
    def get_access_token(code, redirect_uri)
      params = {
        client_id:      client_id,
        client_secret:  client_secret,
        grant_type:     'authorization_code',
        code:           code,
        redirect_uri:   redirect_uri
      }
      post("/oauth/token/", params, raw=false)
    end
  end
end
