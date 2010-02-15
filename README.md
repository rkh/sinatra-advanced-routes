Sinatra::AdvancedRoutes
=======================

AdvancedRoutes makes routes first class objects in [Sinatra](http://sinatrarb.com)

BigBand
-------

AdvancedRoutes is part of the [BigBand](http://github.com/rkh/big_band) stack.
Check it out if you are looking for other fancy Sinatra extensions.

Example
-------

  require "sinatra"
  require "sinatra/advanced_routes"

  admin_route = get "/admin" do
    administrate_stuff
  end

  before do
    # Let's deactivate the route if we have no password file.
    if File.exists? "admin_password" then admin_route.activate
    else admin_route.deactivate 
    end
  end

  first_route = get "/:name" do
   # stuff
  end

  other_route = get "/foo_:name" do
    # other stuff
  end

  # Unfortunatly first_route will catch all the requests other_route would
  # have gotten, since it has been defined first. But wait, we can fix this!
  other_route.promote

Usage with Sinatra::Base
------------------------

  require "sinatra/base"
  require "sinatra/advanced_routes"
  
  class Foo < Sinatra::Base
    register Sinatra::AdvancedRoutes
  end
