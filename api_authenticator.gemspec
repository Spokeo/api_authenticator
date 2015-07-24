# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'api_authenticator/version'

Gem::Specification.new do |spec|
  spec.name          = "api_authenticator"
  spec.version       = ApiAuthenticator::VERSION
  spec.authors       = ["Austin Fonacier"]
  spec.email         = ["austinrf@gmail.com"]
  spec.summary       = "This gem will authenticate API requests using a modified HMAC-SHA1"
  spec.description   = "This gem will authenticate API requests using a modified HMAC-SHA1"
  spec.homepage      = "https://github.com/Spokeo/api_authenticator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 3.3.0'
  spec.add_dependency "activesupport"
end