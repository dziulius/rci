require File.dirname(__FILE__) + "/../spec_helper"

describe Project do

  it "should return name when calling to_s" do
    build :psi
    @psi.to_s.should == @psi.name
  end
end