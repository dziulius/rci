require File.dirname(__FILE__) + "/../spec_helper"

describe "Core extensions" do
  describe Date do
    it "show difference in work days" do
      d = Date.new(2009, 11, 4)
      d.work_days_between(Date.new(2009, 11, 5)).should == 2
      d.work_days_between(Date.new(2009, 11, 11)).should == 6
      d.work_days_between(Date.new(2009, 11, 10)).should == 5
      d.work_days_between(Date.new(2009, 11, 12)).should == 7
      d.work_days_between(Date.new(2009, 11, 23)).should == 14

      #until weekend
      d.work_days_between(Date.new(2009, 11, 7)).should == 3
      d.work_days_between(Date.new(2009, 11, 8)).should == 3
      d.work_days_between(Date.new(2009, 11, 14)).should == 8
      d.work_days_between(Date.new(2009, 11, 15)).should == 8

      #from weekend
      Date.new(2009, 11, 7).work_days_between(d).should == 3
      Date.new(2009, 11, 8).work_days_between(d).should == 3
      Date.new(2009, 11, 14).work_days_between(d).should == 8
      Date.new(2009, 11, 15).work_days_between(d).should == 8

      #between weekends
      Date.new(2009, 11, 7).work_days_between(Date.new(2009, 11, 8)).should == 0
      Date.new(2009, 11, 7).work_days_between(Date.new(2009, 11, 15)).should == 5
      Date.new(2009, 11, 7).work_days_between(Date.new(2009, 11, 14)).should == 5
      Date.new(2009, 11, 8).work_days_between(Date.new(2009, 11, 14)).should == 5
      Date.new(2009, 11, 8).work_days_between(Date.new(2009, 11, 15)).should == 5
    end
  end
end
