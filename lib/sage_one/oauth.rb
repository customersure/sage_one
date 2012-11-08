require 'sage_one/connection'
require 'sage_one/request'

module SageOne

  module OAuth
    include Connection
    include Request

    # Return URL for OAuth authorization
    def authorize_url(options={})
      options[:response_type] ||= "code"
      params = { :client_id => client_id }.merge(options)
      connection.build_url("/oauth/authorize/", params).to_s
    end

    # Return an access token from authorization
    def get_access_token(code, options={})
      options[:grant_type] ||= "authorization_code"
      params = { :client_id => client_id, :client_secret => client_secret }.merge(options)
      post("/oauth/token/", params.merge(:code => code), raw=false, unformatted=true)
    end

  end

end