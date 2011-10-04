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
    before :all do
      @port = 5243
      Thread.new do
        rhr "server --port #{@port}"
      end
    end

    it "can get /" do
      `curl "http://localhost:#{@port}"`.should == 'TEST'
    end

    it "can get index.erb" do
      `curl "http://localhost:#{@port}/index.erb"`.should == 'TEST'
    end

    it "can get plain html" do
      `curl "http://localhost:#{@port}/plain.html"`.should == "<%= 'TEST' %>"
    end
  end
end
