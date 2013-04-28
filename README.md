# sinatra-advanced-routes

> Makes routes first class objects in [Sinatra](http://sinatrarb.com).

[![Build Status](https://travis-ci.org/rkh/sinatra-advanced-routes.png)](https://travis-ci.org/rkh/sinatra-advanced-routes)
[![Gem Version](https://badge.fury.io/rb/sinatra-advanced-routes.png)](https://rubygems.org/gems/sinatra-advanced-routes)
[![Code Climate](https://codeclimate.com/github/rkh/sinatra-advanced-routes.png)](https://codeclimate.com/github/rkh/sinatra-advanced-routes)

Check out [sinatra-contrib](https://github.com/sinatra/sinatra-contrib) you are looking for other fancy Sinatra extensions.

## Installation

```ruby
# Gemfile
gem 'sinatra-advanced-routes', :require => 'sinatra/advanced_routes'
```

If you are serving a [modular application](https://github.com/sinatra/sinatra#modular-vs-classic-style), 
register the extension manually :

```ruby
require 'sinatra/base'
require 'sinatra/advanced_routes'

class Foo < Sinatra::Base
  register Sinatra::AdvancedRoutes
end
```

## Examples

### Route manipulation

```ruby
require 'sinatra'
require 'sinatra/advanced_routes'

admin_route = get '/admin' do
  administrate_stuff
end

before do
  # Let's deactivate the route if we have no password file.
  if File.exists? 'admin_password' then admin_route.activate
  else admin_route.deactivate 
  end
end

first_route = get '/:name' do
  # stuff
end

other_route = get '/foo_:name' do
  # other stuff
end

# Unfortunatly first_route will catch all the requests other_route would
# have gotten, since it has been defined first. But wait, we can fix this!
other_route.promote
```

### Route inspection

```ruby
require 'some_sinatra_app'

SomeSinatraApp.each_route do |route|
  puts '-' * 20
  puts route.app.name   # "SomeSinatraApp"
  puts route.path       # that's the path given as argument to get and akin
  puts route.verb       # get / head / post / put / delete
  puts route.file       # "some_sinatra_app.rb" or something
  puts route.line       # the line number of the get/post/... statement
  puts route.pattern    # that's the pattern internally used by sinatra
  puts route.keys       # keys given when route was defined
  puts route.conditions # conditions given when route was defined
  puts route.block      # the route's closure
end
```

Some of that fields (like conditions or pattern) can be changed, which will take immediate effect on the routing.
