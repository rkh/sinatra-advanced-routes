SPEC = Gem::Specification.new do |s|
  s.name             = "sinatra-advanced-routes"
  s.version          = "0.5.2"
  s.description      = "Make Sinatra routes first class objects."

  s.add_dependency "sinatra", "~> 1.0"
  s.add_development_dependency "rspec", ">= 1.3.0"
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'sinatra-contrib'

  # Those should be about the same in any BigBand extension.
  s.authors          = ["Konstantin Haase"]
  s.email            = "konstantin.mailinglists@googlemail.com"
  s.files            = Dir["**/*.{rb,md}"] << "LICENSE"
  s.has_rdoc         = 'yard'
  s.homepage         = "http://github.com/rkh/#{s.name}"
  s.require_paths    = ["lib"]
  s.summary          = s.description
  
end
