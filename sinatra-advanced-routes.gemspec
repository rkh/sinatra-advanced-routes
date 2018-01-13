SPEC = Gem::Specification.new do |s|
  s.name             = "sinatra-advanced-routes"
  s.version          = "0.5.3"
  s.description      = "Make Sinatra routes first class objects."


  # Those should be about the same in any BigBand extension.
  s.authors          = ["Konstantin Haase", "Jean-Philippe Doyle"]
  s.email            = "konstantin.mailinglists@googlemail.com"
  s.files            = Dir["**/*.{rb,md}"] << "LICENSE"
  s.has_rdoc         = 'yard'
  s.homepage         = "http://github.com/rkh/#{s.name}"
  s.require_paths    = ["lib"]
  s.summary          = s.description
  
end
