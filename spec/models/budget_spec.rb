require File.dirname(__FILE__) + "/../spec_helper"

describe Budget do
  it "should have date string" do
    build 'budgets.of_psi.at_0910'
    @budgets_of_psi_at_0910.at_string.should == '2009 October'
  end
end