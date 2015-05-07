# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'platter/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = ">= #{Platter::RUBY_VERSION}"
  spec.name          = "platter"
  spec.version       = Platter::VERSION
  spec.authors       = ["Icalia Labs", "Abraham Kuri"]
  spec.email         = ["kurenn@icalialabs.com"]
  spec.summary       = %q{ A solution to create custom Rails apps used at @icalialabs }
  spec.description   = %q{ A solution to create custom Rails apps used at @icalialabs }
  spec.homepage      = "https://github.com/IcaliaLabs/platter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['platter'] #spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'rails', Platter::RAILS_VERSION
  spec.add_dependency 'thor'
end
