require 'spec_helper'

describe SageOne::Connection  do

  let(:client)              { SageOne.new }
  let(:basic_middleware)    { %w(FaradayMiddleware::EncodeJson FaradayMiddleware::OAuth2 FaradayMiddleware::RaiseSageOneException) }
  let(:non_raw_middleware)  { %w(FaradayMiddleware::Mashify FaradayMiddleware::ParseJson) }

  it "returns a Faraday" do
    expect(client.send(:connection)).to be_a(Faraday::Connection)
  end

  it "sets up mandatory headers" do
    headers = client.send(:connection).headers

    { "Accept"        => /application\/json/,
      "User-Agent"    => /SageOne Ruby Gem/,
      "Content-Type"  => /application\/json/ }.each do |header, value|
        expect(headers[header]).to match(value)
    end
  end

  it "has the correct middleware stack" do
    stack = client.send(:connection).builder.handlers.map(&:name)
    (basic_middleware + non_raw_middleware).each { |mw| expect(stack).to include(mw) }
  end

  context 'raw connection requested' do
    it 'does not include mashify or parse_json' do
      client.raw_response = true
      stack = client.send(:connection).builder.handlers.map(&:name)
      (non_raw_middleware).each { |mw| expect(stack).to_not include(mw) }
    end
  end

end
