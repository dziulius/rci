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
        @psi.users_and_budget.should == [[@andrius, @admin], 411]
      end

      it "should allow selecting between specific months" do
        @psi.users_and_budget('2009/12'..'2010/1').should == [[@andrius, @admin], 127]
      end

      it "should only show users that worked in that period" do
        @psi.users_and_budget('2010/1'..'2010/2').should == [[@admin], 12]
      end
    end
  end
end