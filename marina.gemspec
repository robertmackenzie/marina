# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marina/version'

Gem::Specification.new do |spec|
  spec.name          = "marina"
  spec.version       = Marina::VERSION
  spec.authors       = ["Robert Mackenzie"]
  spec.email         = ["robertmackenzie@gmail.com"]
  spec.description   = %q{ Encourages you to declare any hosts file entries you need alongside your project in a Hostspec file. You can then use this tool to update your hosts file against your Hostspec file. Similar style to gems with bundler. }
  spec.summary       = %q{ Encourages you to declare any hosts file entries you need alongside your project in a Hostspec file. You can then use this tool to update your hosts file against your Hostspec file. Similar style to gems with bundler. }
  spec.homepage      = "http://robertmackenzie.githib.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "pry"
end
