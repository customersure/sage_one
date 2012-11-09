require 'spec_helper'

describe SageOne::Client do

  it 'creates accessors for all the keys in the SageOne::Configuration::VALID_OPTIONS_KEYS constant' do
    client = SageOne::Client.new
    SageOne::Configuration::VALID_OPTIONS_KEYS.each_with_index do |method, i|
      value = "Setting attribute #{i}"
      client.send("#{method}=", value)
      expect(client.send(method)).to eq(value)
    end
  end

  describe 'initialize' do
    it 'copies the SageOne.options to the new client' do
      client = SageOne::Client.new
      SageOne::Configuration::VALID_OPTIONS_KEYS.each do |method|
        expect(client.send(method)).to eq(SageOne.options[method])
      end
    end
    it 'allows you to override any config options' do
      better_options = {
        adapter: 'BestAdaptor',
        faraday_config_block: 'blocky block',
        api_endpoint: 'https://www.example.com/',
        proxy: 'proxy.example.com',
        access_token: 'let_me_in',
        client_id: 'client123',
        client_secret: 'secret',
        user_agent: 'Gem Awesome',
        request_host: 'example.com',
        auto_traversal: true
      }
      client = SageOne::Client.new(better_options)
      SageOne::Configuration::VALID_OPTIONS_KEYS.each do |method|
        expect(client.send(method)).to eq(better_options[method])
      end
    end
  end
end
