require File.dirname(__FILE__) + "/../spec_helper"

describe FormattingHelper do
  it "should show linked object" do
    build :andrius
    formatter = helper.linked(:name, 'a')
    formatter.to_sym.should == :name
    formatter.to_s(@andrius).should == helper.link_to(@andrius.name, @andrius)
  end

  it "should show number with percent" do
    @andrius = stub
    @andrius.stubs(:work_hours).returns(100, 100, 13)
    @andrius.stubs(:remaining).returns(8, -8, 8)


    formatter = helper.with_percent(:remaining, :work_hours)
    formatter.to_sym.should == :remaining
    ["8 (8.000%)", "-8 (-8.000%)", "8 (61.538%)"].each do |result|
      formatter.to_s(@andrius).should == result
    end
  end

  it "should return random number in range" do
    FormattingHelper.expects(:rand).with(30).returns(23)
    formatter = helper.random(:hours, 100..130)
    formatter.to_sym.should == :hours
    formatter.to_s(nil).should == '123'
  end
end
