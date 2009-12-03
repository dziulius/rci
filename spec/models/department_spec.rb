require File.dirname(__FILE__) + "/../spec_helper"

describe Department do
  it "should return department name when calling to_s" do
    build :main_dep
    @main_dep.to_s.should == @main_dep.name
  end

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

  it "should show department projects" do
    build :tasks, :tasks_of_julius_project, :in_main_dep, :in_second_dep
    @main_dep.projects.collect {|p| p.id }.should =~ [@zks.id, @psi.id]
    @second_dep.projects.should == [@julius_project]
  end

  it "should show department budgets by date" do
    build 'tasks.of_psi', :tasks_of_julius_project, :in_main_dep, :in_second_dep
    @main_dep.budgets.should == @budgets_of_psi.sort_by {|b| b.at }.reverse
    @second_dep.projects.should == [@julius_project]
  end

  describe 'users with work hours' do
    it "should display users with their work hours" do
      build :tasks, :tasks_of_julius_project, :in_main_dep, :in_second_dep
      Date.stubs(:current).returns(Date.new(2010, 2, 28))
      @main_dep.should have(2).users_with_work_hours

      #admin
      @main_dep.users_with_work_hours.detect {|u| u.name == 'admin' }.tap do |u|
        u.work_hours.should == 389
        u.own_work_hours.should == 213
        u.foreign_work_hours.should == 176
        u.start_at.should == Date.new(2009, 10)
        u.end_at.should == Date.new(2010, 2, 28)
        u.lazy_hours.should == 467
      end

      #andrius
      @main_dep.users_with_work_hours.detect {|u| u.name == 'andrius' }.tap do |u|
        u.work_hours.should == 352
        u.own_work_hours.should == 252
        u.foreign_work_hours.should == 100
        u.lazy_hours.should == 176
        u.start_at.should == Date.new(2009, 10)
        u.end_at.should == Date.new(2009, 12, 31)
      end
      #andrius with date
      @main_dep.users_with_work_hours("2009/12", "2010/02").detect {|u| u.name == 'andrius' }.tap do |u|
        u.work_hours.should == 64
        u.own_work_hours.should == 64
        u.foreign_work_hours.should == 0
        u.lazy_hours.should == 120
        u.start_at.should == Date.new(2009, 12)
        u.end_at.should == Date.new(2009, 12, 31)
      end

    end
  end
end
