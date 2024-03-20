# encoding: utf-8
require File.expand_path('../lib/sage_one/version', __FILE__)

Gem::Specification.new do |s|
  s.add_dependency 'addressable', '~>2.3'
  s.add_dependency 'faraday', '>= 1.0'
  s.add_dependency 'faraday_middleware', '>= 1.0'
  s.add_dependency 'hashie', '>=3.0'
  s.add_dependency 'multi_json', '~> 1.4'

  s.add_development_dependency 'json'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'yard'

  s.authors = ['Luke Brown', 'Chris Stainthorpe']
  s.email = ['tsdbrown@gmail.com', 'chris@randomcat.co.uk']
  s.name = 'sage_one'
  s.platform = Gem::Platform::RUBY
  s.homepage = 'https://github.com/customersure/sage_one'
  s.summary = %q{Ruby wrapper for the Sage One V1 API.}
  s.description = s.summary
  s.rubyforge_project = s.name
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  s.version = SageOne::VERSION
end
