require 'sinatra'
require 'sinatra/test_helpers'
require 'sinatra/advanced_routes'
require 'rspec'
require 'rack/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Sinatra::TestHelpers
end