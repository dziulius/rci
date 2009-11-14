require File.dirname(__FILE__) + "/../spec_helper"

describe Department do
  describe "leader_id" do
    before do
      build 'in_main_dep.admin_leads'
    end

    it "should show correct leader_id" do
      @main_dep.leader_id.should == @admin.id
    end

    it "should assign correct leader when assigning leader_id" do
      build 'in_main_dep.andrius_works'
      @main_dep.leader_id = @andrius.id
      @main_dep.leader.should == @andrius
      @admin.department_belonging.leader.should be_false
    end

    it "should allow assigning leader even if there was none" do
      @admin.department_belonging.update_attribute(:leader, false)

      @main_dep.leader_id = @admin.id
      @main_dep.leader.should == @admin
    end
  end
end