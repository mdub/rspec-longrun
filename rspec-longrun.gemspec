# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rspec/longrun/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mike Williams"]
  gem.email         = ["mdub@dogbiscuit.org"]
  gem.summary       = "An RSpec formatter for long-running specs."
  gem.homepage      = "http://github.com/mdub/rspec-longrun"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rspec-longrun"
  gem.require_paths = ["lib"]
  gem.version       = RSpec::Longrun::VERSION

  gem.add_runtime_dependency("rspec-core", ">= 3.7.0")

end
