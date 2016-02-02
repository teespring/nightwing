require File.expand_path("../lib/robin/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "robin"
  s.version     = Robin::VERSION
  s.date        = "2016-01-26"
  s.summary     = "Sidekiq metrics gathering"
  s.description = "Sidekiq metrics gathering"
  s.authors     = ["Chris Ledet"]
  s.email       = "chris.ledet@teespring.com"
  s.files       = `git ls-files`.split
  s.homepage    = "https://github.com/teespring/robin"
  s.license     = "MIT"

  s.add_runtime_dependency "sidekiq", ">= 3.0"
  s.add_runtime_dependency "activesupport", ">= 4.1.0"

  s.add_development_dependency "rubocop", "~> 0.36"
  s.add_development_dependency "rspec", "~> 3.4.0"
  s.add_development_dependency "rspec_junit_formatter", ">= 0.2.3"
end
