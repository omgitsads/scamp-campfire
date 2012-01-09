# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "scamp-campfire-adapter/version"

Gem::Specification.new do |s|
  s.name        = "scamp-campfire-adapter"
  s.version     = Scamp::Campfire::Adapter::VERSION
  s.authors     = ["Adam Holt"]
  s.email       = ["me@adamholt.co.uk"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "scamp-campfire-adapter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_dependency "scamp", "2.0.0.pre"
  s.add_dependency "eventmachine", '1.0.0.beta.4'
  s.add_dependency "tinder", "~> 1.8.0"
end
