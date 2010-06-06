require File.expand_path("../../spec_helper", __FILE__)

describe Sinatra::AdvancedRoutes do
  before { app :AdvancedRoutes }
  it_should_behave_like 'sinatra'

  [:get, :head, :post, :put, :delete].each do |verb|
    describe "HTTP #{verb.to_s.upcase}" do

      describe "activation" do

        it "is able to deactivate routes from the outside" do
          route = define_route(verb, "/foo") { "bar" }
          route.should be_active
          browse_route(verb, "/foo").should be_ok
          route.deactivate
          route.should_not be_active
          browse_route(verb, "/foo").should_not be_ok
        end

        it "is able to deacitvate routes from a before filter" do
          route = define_route(verb, "/foo") { "bar" }
          app.before { route.deactivate }
          route.should be_active
          browse_route(verb, "/foo").should_not be_ok
          route.should_not be_active
        end

        it "is able to reactivate deactivated routes" do
          route = define_route(verb, "/foo") { "bar" }
          route.deactivate
          route.activate
          route.should be_active
          browse_route(verb, "/foo").should be_ok
        end

      end

      describe "inspection" do
        before { @route = define_route(verb, "/foo") { } }
        it("exposes app")        { @route.app.should        == app                  }
        it("exposes path")       { @route.path.should       == "/foo"               }
        it("exposes file")       { @route.file.should       == __FILE__.expand_path }
        it("exposes verb")       { @route.verb.should       == verb.to_s.upcase     }
        it("exposes pattern")    { @route.pattern.should    == @route[0]            }
        it("exposes keys")       { @route.keys.should       == @route[1]            }
        it("exposes conditions") { @route.conditions.should == @route[2]            }
        it("exposes block")      { @route.block.should      == @route[3]            }
      end

      describe "promotion" do
        it "preffers promoted routes over earlier defined routes" do
          next if verb == :head # cannot check body for head
          bar = define_route(verb, "/foo") { "bar" }
          baz = define_route(verb, "/foo") { "baz" }
          browse_route(verb, "/foo").body.should == "bar"
          baz.promote
          browse_route(verb, "/foo").body.should == "baz"
          bar.promote
          browse_route(verb, "/foo").body.should == "bar"
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
end
