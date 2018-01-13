require File.expand_path("../../spec_helper", __FILE__)

set :environment, :test

describe Sinatra::AdvancedRoutes do

  def app
    Sinatra::Application
  end


	shared_context "clear up" do
		after :all do
			app.instance_variable_set :@routes, {}
		end
	end

  before { mock_app { register Sinatra::AdvancedRoutes }}

  [:head, :get, :post, :put, :delete].each do |verb|
    describe "HTTP #{verb.to_s.upcase}" do

      describe "activation" do

				context "from the outside" do
					include_context "clear up"
					before :all do
						@route = define_route(verb, "/foo") { "bar" }
					end

					it "should be able to activate a route" do
						@route.should be_active
						browse_route(verb, "/foo").should be_ok
					end
					context "deactivated" do
					 it "is able to deactivate route" do
						 @route.deactivate
						 @route.should_not be_active
					 end
					 it "should not be browsable" do
						 browse_route(verb, "/foo").should_not be_ok
					 end
					end
      	end



				context "before filter" do
					include_context "clear up"
					it "is able to deactivate routes from a before filter" do
						route = define_route(verb, "/foo") { "bar" }
						app.before { route.deactivate }
						route.should be_active
						browse_route(verb, "/foo").should_not be_ok
						route.should_not be_active
					end
				end

				context "deactivated routes" do
					include_context "clear up"
					it "is able to reactivate them" do
						route = define_route(verb, "/foo") { "bar" }
						route.deactivate
						route.activate
						route.should be_active
						browse_route(verb, "/foo").should be_ok
					end
				end
      end

      describe "inspection" do
				include_context "clear up"
        before { @route = define_route(verb, "/foo") { } }
        it("exposes app")        { @route.app.should        == app                  }
        it("exposes path")       { @route.path.should       == "/foo"               }
        it("exposes file")       { @route.file.should       == File.expand_path(__FILE__) }
        it("exposes verb")       { @route.verb.should       == verb.to_s.upcase     }
        it("exposes pattern")    { @route.pattern.should    == @route[0]            }
        it("exposes keys")       { @route.keys.should       == @route[1]            }
        it("exposes conditions") { @route.conditions.should == @route[2]            }
        it("exposes block")      { @route.block.should      == @route[3]            }
      end

      describe "promotion" do
				next if verb == :head # cannot check body for head
				before :each do
          @bar = define_route(verb, "/foo") { "bar" }
          @baz = define_route(verb, "/foo") { "BAZ" }
        end
        context "Before" do
				  Then { browse_route(verb, "/foo").body.should == "bar" }
				  include_context "clear up"
				end

        context "preffers promoted routes over earlier defined routes" do
        	context "single promotion" do
						include_context "clear up"
						When { @baz.promote }
						Then { browse_route(verb, "/foo").body.should == "BAZ" }
					end
					context "Double promotion, full circle" do
						include_context "clear up"
						When { @baz.promote; @bar.promote }
						Then { browse_route(verb, "/foo").body.should == "bar" }
					end
        end
      end

      describe "hooks" do
        before do
          @extension = Module.new
          app.register @extension
        end

        it "triggers advanced_root_added hook" do
          meth = @extension.should_receive(:advanced_route_added)
          verb == :get ? meth.twice : meth.once
          define_route(verb, "/foo") { }
        end

        it "triggers advanced_root_activated hook" do
          route = define_route(verb, "/foo") { }
          route.deactivate
          meth = @extension.should_receive(:advanced_route_activated)
          verb == :get ? meth.twice : meth.once
          route.activate
        end

        it "triggers advanced_root_deactivated hook" do
          route = define_route(verb, "/foo") { }
          meth = @extension.should_receive(:advanced_route_deactivated)
          verb == :get ? meth.twice : meth.once
          route.deactivate
        end
      end

    end
  end

  def define_route(verb, *args, &block)
    app.send(verb, *args, &block)
  end

  def browse_route(verb, *args, &block)
    send(verb, *args, &block)
    last_response
  end
end
