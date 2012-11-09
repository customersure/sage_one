unless ENV['CI']
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec"
  end
end

require 'sage_one'
require 'rspec'
require 'webmock/rspec'

RSpec.configure do |config|
  config.color_enabled = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end

def a_delete(url)
  a_request(:delete, sage_url(url))
end

def a_get(url)
  a_request(:get, sage_url(url))
end

def a_patch(url)
  a_request(:patch, sage_url(url))
end

def a_post(url)
  a_request(:post, sage_url(url))
end

def a_put(url)
  a_request(:put, sage_url(url))
end

def stub_delete(url)
  stub_request(:delete, sage_url(url))
end

def stub_get(url)
  stub_request(:get, sage_url(url))
end

def stub_post(url)
  stub_request(:post, sage_url(url))
end

def stub_put(url)
  stub_request(:put, sage_url(url))
end

def sage_url(url)
  if url =~ /^http/
    url
  else
    "https://app.sageone.com/api/v1/#{url}"
  end
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
