# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'chatspry/version'

Gem::Specification.new do |spec|

  spec.name          = "chatspry"
  spec.version       = Chatspry::VERSION

  spec.authors       = [ "Philip Vieira" ]
  spec.email         = [ "philip@chatspry.com" ]

  spec.summary       = %q{API wrapper for chatspry in ruby}
  spec.description   = %q{API wrapper for chatspry in ruby}

  spec.homepage      = "http://developer.chatspry.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.require_paths = [ "lib" ]

  spec.add_dependency "faraday", "~> 0.9"

  spec.add_development_dependency "bundler",  "~> 1.6"
  spec.add_development_dependency "rspec",    "~> 3.0.0"
  spec.add_development_dependency "rake"

end
