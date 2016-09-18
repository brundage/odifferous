# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odifferous/version'

Gem::Specification.new do |spec|
  spec.name          = "odifferous"
  spec.version       = Odifferous.version
  spec.authors       = ["Dean Brundage"]
  spec.email         = ["github@deanandadie.net"]

  spec.summary = 'Olfactometer residence time calculator'
  spec.description = 'A gem to calculate time spent in a olfactometer'
  spec.homepage = 'https://github.com/brundage/odifferous'
  spec.rubyforge_project = "odifferous"

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = Dir["{lib}/**/*.rb"] + ['README']
  spec.require_paths = ['lib']
  spec.test_files = [ 'spec/odifferous.spec' ]

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

end
