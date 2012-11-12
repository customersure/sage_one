require 'spec_helper'

describe SageOne::Configuration do

  subject do
    module TestConfigModule
      extend SageOne::Configuration
    end
  end

  it 'has some default constants setup' do
    expect(SageOne::Configuration::DEFAULT_ADAPTER).to eq(Faraday.default_adapter)
    expect(SageOne::Configuration::DEFAULT_API_VERSION).to eq(1)
    expect(SageOne::Configuration::DEFAULT_API_ENDPOINT).to eq('https://app.sageone.com/api/v1/')
    expect(SageOne::Configuration::DEFAULT_USER_AGENT).to eq("SageOne Ruby Gem #{SageOne::VERSION}")
    expect(SageOne::Configuration::DEFAULT_AUTO_TRAVERSAL).to be_false
    expect(SageOne::Configuration::DEFAULT_RAW_RESPONSE).to be_false
    expect(SageOne::Configuration::VALID_OPTIONS_KEYS).to be_a(Array)
  end

  describe 'attr_accessors' do
    it 'creates accessors for all the keys in the VALID_OPTIONS_KEYS constant' do
      SageOne::Configuration::VALID_OPTIONS_KEYS.reject { |k| [:api_endpoint].include?(k) }.each_with_index do |method, i|
        value = "Setting attribute #{i}"
        subject.send("#{method}=", value)
        expect(subject.send(method)).to eq(value)
      end
    end
    it 'uses an overridden method for setting the api_endpoint which ensures a trailing forward slash is present' do
      subject.api_endpoint = 'http://www.example.com'
      expect(subject.api_endpoint).to eq('http://www.example.com/')
    end
  end

  describe "faraday_config" do
    it 'assigns the given block to faraday_config_block' do
      p = lambda { 'hi' }
      subject.faraday_config(&p)
      expect(subject.faraday_config_block.call).to eq('hi')
    end
  end

  describe 'configure' do
    it 'yields the given block passing in self - allowing you to config attributes' do
      value = "my new client id"

      subject.configure do |config|
        config.client_id = value
      end

      expect(subject.client_id).to eq(value)
    end
  end

  describe 'options' do
    it 'returns a new hash of all the config options' do
      expect(subject.options).to be_a(Hash)
      expect(subject.options.keys).to eq(SageOne::Configuration::VALID_OPTIONS_KEYS)
      expect(subject.options[:adapter]).to eq(SageOne::Configuration::DEFAULT_ADAPTER)
    end
  end

  describe 'extended' do
    it 'calls reset on module extending it' do
      module NewMod; end
      NewMod.should_receive(:reset).once
      NewMod.extend(SageOne::Configuration)
    end
  end

  describe 'reset' do
    it 'resets all the config options to the default values' do
      # Change them first
      SageOne::Configuration::VALID_OPTIONS_KEYS.each { |method| subject.send("#{method}=", 'something') }
      subject.reset
      expect(subject.adapter).to eq(SageOne::Configuration::DEFAULT_ADAPTER)
      expect(subject.api_endpoint).to eq(SageOne::Configuration::DEFAULT_API_ENDPOINT)
      expect(subject.proxy).to be_nil
      expect(subject.access_token).to be_nil
      expect(subject.client_id).to be_nil
      expect(subject.client_secret).to be_nil
      expect(subject.request_host).to be_nil
      expect(subject.user_agent).to eq(SageOne::Configuration::DEFAULT_USER_AGENT)
      expect(subject.auto_traversal).to be_false
      expect(subject.raw_response).to be_false
    end
  end

end