# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "much-plugin/version"

Gem::Specification.new do |gem|
  gem.name        = "much-plugin"
  gem.version     = MuchPlugin::VERSION
  gem.authors     = ["Kelly Redding", "Collin Redding"]
  gem.email       = ["kelly@kellyredding.com", "collin.redding@me.com"]
  gem.description = %q{An API to ensure mixin included logic (the "plugin") only runs once.}
  gem.summary     = %q{An API to ensure mixin included logic (the "plugin") only runs once.}
  gem.homepage    = "http://github.com/redding/much-plugin"
  gem.license     = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("assert", ["~> 2.15"])

end
