require 'spec_helper'

describe RHR do
  def rhr(command)
    `cd spec/site && ../../bin/rhr #{command}`
  end

  it "has a VERSION" do
    RHR::VERSION.should =~ /^[\.\da-z]+$/
  end

  it "has a commandline version" do
    rhr("-v").should =~ /^[\.\da-z]+$/m
  end

  it "has a commandline help" do
    rhr("-h").should =~ /Ruby Hypertext Refinement/
  end

  describe 'server' do
    include Rack::Test::Methods

    before :all do
      Dir.chdir 'spec/site'
    end

    def app
      RHR::Server.new
    end

    it "can get /" do
      get '/'
      last_response.body.should == 'TEST'
    end

    it "evaluates erb files" do
      get '/index.erb'
      last_response.body.should == 'TEST'
      last_response.content_type.should == 'text/html'
    end

    it "can get static files" do
      get '/plain.html'
      last_response.body.should == "<%= 'TEST' %>\n"
    end

    it "does not server monkey paths" do
      get '/xxx/../plain.html'
      last_response.status.should == 404
    end

    it "can get nested index.erb" do
      get '/xxx'
      last_response.body.should == "NESTED"
    end

    it "can get nested index.erb with trailing slash" do
      get '/xxx/'
      last_response.body.should == "NESTED"
    end

    it "can get nested index without template language" do
      get '/yyy'
      last_response.body.should == "Foo\n"
    end

    it "can get static files with correct content-type" do
      get "/people.jpg"
      last_response.content_type.should == 'image/jpeg'
    end

    it "ignores common ruby files" do
      get "/Gemfile"
      last_response.status.should == 404
    end

    it "ignores _files"
    it "ignores .files"
    it "ignores _folders"
  end
end
