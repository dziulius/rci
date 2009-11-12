require 'spec_helper'

describe ProjectsHelper do
  describe "hours spent" do
    it "should be shown in orange if project is under budget" do
      build :tasks
      helper.hours_worked(@psi).should have_tag('p', :text => 'Total hours worked: 404/411 (98%)') do
        with_tag('span.orange', :text => '404')
        with_tag('span.orange', :text => '98%')
      end
    end

    it "should be shown in green if project is exactly on budget" do
      build :tasks
      @andrius.tasks.create!(:budget => @budgets_of_psi_at_1002, :work_hours => 7)
      helper.hours_worked(@psi).should have_tag('p', :text => 'Total hours worked: 411/411 (100%)') do
        with_tag('span.green', :text => '411')
        with_tag('span.green', :text => '100%')
      end
    end

    it "should be shown in red if project is over budget" do
      build :tasks
      @andrius.tasks.create!(:budget => @budgets_of_psi_at_1002, :work_hours => 12)
      helper.hours_worked(@psi).should have_tag('p', :text => 'Total hours worked: 416/411 (101%)') do
        with_tag('span.red', :text => '416')
        with_tag('span.red', :text => '101%')
      end
    end
  end
end
