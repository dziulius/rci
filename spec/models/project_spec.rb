require File.dirname(__FILE__) + "/../spec_helper"

describe Project do
  before do
    build :psi
  end

  it "should return name when calling to_s" do
    @psi.to_s.should == @psi.name
  end

  it "should delegate department to leader" do
    build :in_main_dep
    @psi.department.should == @psi.leader.department
    @psi.department_id.should == @psi.leader.department.id
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

  describe "users" do
    before do
      build :tasks
    end

    it "should return all users that have tasks in particular project" do
      @psi.users.should == [@andrius, @admin]
      @zks.users.should == [@andrius]
    end

    it "should show how much each user has worked on project" do
      (@psi.users + @zks.users).collect(&:work_hours).should == [191, 213, 61]
    end

    describe 'and budget' do
      it "should allow selecting all" do
        @psi.users_and_budget.should == [[@andrius, @admin], 411, 404]
      end

      it "should allow selecting between specific months" do
        @psi.users_and_budget('2009/12'..'2010/1').should == [[@andrius, @admin], 127, 127]
      end

      it "should only show users that worked in that period" do
        @psi.users_and_budget('2010/1'..'2010/2').should == [[@admin], 12, 13]
      end
    end
  end

  describe "work hours" do
    before :each do
      build :tasks, :in_main_dep, :in_second_dep
      @admin.department_belonging.update_attributes(:department_id => @second_dep.id)
    end
    it "should show own work hours" do
      @psi.own_work_hours.should == 191
      @zks.own_work_hours.should == 0
    end

    it "should show foreign work hours" do
      @psi.foreign_work_hours.should == 213
      @zks.foreign_work_hours.should == 61
    end
  end

  describe 'budgets with hours' do
    it "should allow viewing them" do
      build 'tasks.of_psi'
      @psi.budgets_with_hours.should have(4).items

      @psi.budgets_with_hours[2].tap do |budget|
        budget.at_string.should == '2009 November'
        budget.hours.should == 142
        budget.used.should == 126
        budget.remaining.should == 16
      end
    end
  end
end
