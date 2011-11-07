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

    def app
      RHR::Server.new
    end

    def write(path, content)
      @files ||= []
      @files << path
      File.open(path,'w'){|f| f.write(content) }
    end

    after do
      (@files || []).each{|f| `rm #{f}` }
    end

    before :all do
      Dir.chdir 'spec/site'
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

    it "ignores _files" do
      get "/_hidden.html"
      last_response.status.should == 404
    end

    it "ignores .files" do
      get "/.hidden.html"
      last_response.status.should == 404
    end

    it "ignores hidden folders" do
      get "/_hidden/xxx.html"
      last_response.status.should == 404
    end

    it "ignores nested hidden" do
      get "/xxx/.hidden.html"
      last_response.status.should == 404
    end

    it "passes env" do
      get "/xxx/env.erb"
      last_response.body.should == "/xxx/env.erb"
    end

    it "passes get params" do
      get "/xxx/params.erb?x=1&a%20b=b%20c"
      last_response.body.should == "[[\"a b\", \"b c\"], [\"x\", \"1\"]]"
    end

    it "passes merged post and get params" do
      post "/xxx/params.erb?a=1&b=2", {'b' => 3}
      last_response.body.should == "[[\"a\", \"1\"], [\"b\", \"3\"]]"
    end

    describe 'with layout' do
      it 'renders the layout if available' do
        write '_layout.erb', '<div><%= yield %></div>'
        get '/'
        last_response.body.should == "<div>TEST</div>"
      end

      it 'does not render non-layout files' do
        write 'no_layout.erb', '<div><%= yield %></div>'
        get '/'
        last_response.body.should == "TEST"
      end
    end

    describe 'with helpers' do
      it 'passes helpers into the view' do
        write 'helpers.rb', 'class Helpers; def self.foo; "hallo"; end; end'
        get "/helpers.erb"
        last_response.body.should == 'hallo'
      end
    end
  end
end
