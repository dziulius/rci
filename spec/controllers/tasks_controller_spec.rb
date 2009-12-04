require 'spec_helper'

describe TasksController do
  before do
    build :tasks
    login @admin
    @budget = @budgets_of_psi_at_0910
    @task = @tasks_of_psi_for_andrius_at_0910
  end

  describe "GET 'edit'" do
    it "should be successful" do
      xhr :get, :edit, :budget_id => @budget.to_param, :id => @task.to_param
      response.should be_success

      assigns(:task).should == @task
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      xhr :get, :new, :budget_id => @budget.to_param
      response.should be_success

      assigns(:task).should be_new_record
      assigns(:task).budget.should == @budget
    end
  end

  describe "POST create" do
    it "create new task with valid params" do
      xhr :post, :create, :task => {:user_id => @andrius.id, :work_hours => 100}, :budget_id => @budget.to_param
      response.should be_success
      flash[:notice].should == "Successfully added new task."
      assigns[:task].should_not be_new_record
    end

    it "should not create new task with invalid params" do
      xhr :post, :create, :task => {}, :budget_id => @budget.to_param
      response.should be_success
      assigns[:task].should be_new_record
    end
  end

  describe "PUT update" do
    it "updates the requested task with valid params" do
      put :update, :id => @task.to_param, :task => {:work_hours => 100}, :budget_id => @budget.to_param
      response.should be_success
      flash[:notice].should == "Successfully updated information."
      assigns[:task].should == @task
      assigns[:task].work_hours.should == 100
    end

    it "does not update task with invalid params" do
      put :update, :id => @task.to_param, :task => {:work_hours => 'a'}, :budget_id => @budget.to_param
      response.should be_success
      assigns[:task].should == @task
      @task.reload.work_hours.should == 66
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested task" do
      xhr :delete, :destroy, :id => @task.to_param, :budget_id => @budget.to_param
      response.should be_success

      assigns(:task).should == @task
      lambda { @task.reload }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
