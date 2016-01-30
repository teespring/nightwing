Gem::Specification.new do |s|
  s.name        = "robin"
  s.version     = "0.0.1"
  s.date        = "2016-01-26"
  s.summary     = "Librato + Sidekiq"
  s.description = "Superior Librato metrics gathering for Sidekiq"
  s.authors     = ["Chris Ledet"]
  s.email       = "chris.ledet@teespring.com"
  s.files       = `git ls-files`.split
  s.homepage    = "https://github.com/teespring/robin"
  s.license     = "MIT"

  s.add_runtime_dependency "sidekiq",      "~> 2.17", ">= 2.17.0"
  s.add_runtime_dependency "librato-rack", "~> 0.4",  ">= 0.4.0"
  s.add_runtime_dependency "activesupport", ">= 4.1.0"

  s.add_development_dependency "rubocop", "~> 0.36"
  s.add_development_dependency "rspec", "~> 3.4.0"
end
