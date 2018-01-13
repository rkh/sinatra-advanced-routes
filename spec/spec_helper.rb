require 'sinatra'
require 'sinatra/test_helpers'
require 'sinatra/advanced_routes'
require 'rspec'
require 'rack/test'
require "simplecov"
require "rspec/given"


if ENV["DEBUG"]
  require 'pry-byebug'
  require "pry-state"
	require 'awesome_print'
  binding.pry
end

SimpleCov.start do
#  add_filter "/test/"
  add_filter "/spec/"
  add_filter "/coverage/"
  add_filter "/vendor.noindex/"
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include Sinatra::TestHelpers
  config.expect_with(:rspec) { |c| c.syntax = :should }
end