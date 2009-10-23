require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it "should show a list of projects user has been working on" do
    build :tasks
    
    @admin.should have(1).projects
    @andrius.should have(2).projects

    @admin.projects[0].tap do |p|
      p.name.should == "PSI"
      p.leader.should == @andrius
      p.start_at.should == Time.mktime(2009, 10)
      p.end_at.should == Time.mktime(2010, 2)
      p.work_hours.should == 213
    end

    @andrius.projects[0].tap do |p|
      p.name.should == "PSI"
      p.leader.should == @andrius
      p.start_at.should == Time.mktime(2009, 10)
      p.end_at.should == Time.mktime(2009, 12)
      p.work_hours.should == 191
    end

    @andrius.projects[1].tap do |p|
      p.name.should == "ZKS"
      p.leader.should == @admin
      p.start_at.should == Time.mktime(2009, 11)
      p.end_at.should == Time.mktime(2009, 11)
      p.work_hours.should == 61
    end
  end
end
