# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rspec/stepper/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mike Williams"]
  gem.email         = ["mdub@dogbiscuit.org"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "rspec-stepper"
  gem.require_paths = ["lib"]
  gem.version       = RSpec::Stepper::VERSION

  gem.add_runtime_dependency("rspec-core", ">= 2.10.0")

end
