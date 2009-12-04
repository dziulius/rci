require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it "should return name when calling to_s" do
    build :andrius
    @andrius.to_s.should == @andrius.name
  end

  it "should show a list of projects user has been working on" do
    build :tasks

    @admin.should have(1).projects
    @andrius.should have(2).projects

    @admin.projects[0].tap do |p|
      p.name.should == "PSI"
      p.leader.should == @andrius
      p.work_hours.should == 213
    end

    projects = @andrius.projects.sort_by(&:name)
    projects[0].tap do |p|
      p.name.should == "PSI"
      p.leader.should == @andrius
      p.work_hours.should == 191
    end

    projects[1].tap do |p|
      p.name.should == "ZKS"
      p.leader.should == @admin
      p.work_hours.should == 61
    end
  end

  it "should allow to create new user" do
    build :main_dep
    user = User.new(:name => 'test user', :password_confirmation =>"secret", :password =>"secret", :department_id => @main_dep.id)
    lambda {
      user.save
    }.should change{User.count}.by(1)
    User.last.should == user
  end

  describe "departments" do
    before do
      build 'in_main_dep.admin_leads'
    end

    it "should return correct department_id" do
      @admin.department_id.should == @main_dep.id
    end

    it "should allow changing department by setting id" do
      build :second_dep
      @admin.department_id = @second_dep.id
      @admin.reload.department.should == @second_dep
    end

    it "should not set user as leader" do
      build :second_dep
      @admin.department_id = @second_dep.id
      @admin.reload.department_belonging.leader.should be_false
    end

    it "should allow setting department_id to nil" do
      @admin.department_id = nil
      @admin.reload.department.should == nil
    end
  end

  describe 'tasks for project' do
    it "should show what tasks user did for project" do
      build :tasks
      @andrius.tasks_for(@psi).should =~ @tasks_of_psi_for_andrius
      @admin.tasks_for(@psi).should =~ @tasks_of_psi_for_admin

      @andrius.tasks_for(@psi).last.at_string.should == "2009 October"
    end
  end
end
