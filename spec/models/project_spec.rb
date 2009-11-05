require File.dirname(__FILE__) + "/../spec_helper"

describe Project do
  before do
    build :psi
  end

  it "should return name when calling to_s" do
    @psi.to_s.should == @psi.name
  end

  it "should have start and end date" do
    build 'budgets.of_psi'
    Time.stubs(:now).returns(Time.gm(2010, 3, 1))
    @psi.start_at.should == Date.new(2009, 10)
    @psi.end_at.should == Date.new(2010, 02, 28)
  end

  it "should have start date and end date as nil if project has no budgets" do
    @psi.start_at.should be_nil
    @psi.end_at.should be_nil
  end
end