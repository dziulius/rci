require File.dirname(__FILE__) + "/../spec_helper"

describe Task do

  it "should automatically update users created_at attribute is created task is before it" do
    build :admin, 'budgets.of_psi.at_0910'
    @admin.tasks.create!(:budget => @budgets_of_psi_at_0910, :work_hours => 10)
    @admin.reload.created_at.should == @budgets_of_psi_at_0910.at
  end
end
