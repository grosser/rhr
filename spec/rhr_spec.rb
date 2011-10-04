require 'spec_helper'

describe RHR do
  it "has a VERSION" do
    RHR::VERSION.should =~ /^[\.\da-z]+$/
  end
end
