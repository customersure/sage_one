require 'spec_helper'

describe SageOne::OAuth do

  let(:client) { SageOne.new(client_id: "CLIENT_ID", client_secret: "CLIENT_SECRET") }

  describe 'authorize_url' do
    it 'returns a correctly formatted url' do
      expect(client.authorize_url('http://www.example.com/endpoint')).to eq("https://app.sageone.com/oauth/authorize/?client_id=CLIENT_ID&redirect_uri=http%3A%2F%2Fwww.example.com%2Fendpoint&response_type=code")
    end
  end

  describe 'get_access_token' do
    it 'returns an object containing an access_token' do

      stub_request(:post, "https://app.sageone.com/oauth/token/").
        with(:body => "{\"client_id\":\"CLIENT_ID\",\"client_secret\":\"CLIENT_SECRET\",\"grant_type\":\"authorization_code\",\"code\":\"uuddlrlr\",\"redirect_uri\":\"http://www.example.com/endpoint\"}",
              :headers => {'Accept'=>'application/json; charset=utf-8', 'Content-Type'=>'application/json', 'User-Agent'=>'SageOne Ruby Gem 0.0.1'}).
        to_return(:body => fixture("oauth_token.json"))

      expect(client.get_access_token('uuddlrlr', 'http://www.example.com/endpoint').access_token).to eq('IguLPAK5VPvDSw3z4SjrkhHTyRXgnnqAPzt1mLUk')
    end
  end

end