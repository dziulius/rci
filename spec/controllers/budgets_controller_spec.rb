require 'spec_helper'

describe BudgetsController do
  before do
    build :tasks
    login @admin
  end

  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
      response.should render_template('budgets/index')
      assigns(:budgets).should == Budget.all
    end

    it "should load project if project_id is passed" do
      get :index, :project_id => @psi.to_param
      response.should be_success
      assigns(:project).should == @psi
      assigns(:budgets).should == @psi.budgets.sort {|a, b| b.at <=> a.at }
      assigns(:budget).should == @budgets_of_psi_at_1002
    end

    it "should return list of users as json for users select tag if department_id passed" do
      build :in_main_dep
      xhr :get, :index, :department_id => @main_dep.to_param, :format => 'json'
      response.should be_success
      response.body.should == User.all.collect{|user| {:val => user.id, :caption => user.name}}.to_json

      assigns(:department).should == @main_dep
    end

    it "should load users budgets if user_id passed" do
      xhr :get, :index, :user_id => @admin.to_param
      response.should render_template('departments/_budgets_table')
      response.should be_success

      assigns(:budgets).should =~ @admin.budgets
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      xhr :get, :new, :project_id => @psi.to_param
      response.should be_success

      assigns(:project).should == @psi
      assigns(:budget).should be_new_record
      assigns(:budget).project.should == @psi
      assigns(:budget).at.should == Date.new(2010, 3)
    end
  end

  describe "POST create" do
    it "create new budget with valid params" do
      xhr :post, :create, :budget => {:at => Date.new(2010, 1).to_s, :hours => 100}, :project_id => @psi.to_param
      response.should be_success
      flash[:notice].should == "Successfully added new budget."
      assigns[:budget].should_not be_new_record
    end

    it "should not create new budget with invalid params" do
      xhr :post, :create, :budget => {}, :project_id => @psi.to_param
      response.should be_success
      assigns[:budget].should be_new_record
    end
  end

  describe "PUT update" do
    it "updates the requested budget with valid params" do
      put :update, :id => @budgets_of_psi_at_1002.to_param, :budget => {:hours => 100}, :project_id => @psi.to_param
      response.should be_success
      flash[:notice].should == "Successfully updated information."
      assigns[:budget].should == @budgets_of_psi_at_1002
      assigns[:budget].hours.should == 100
    end

    it "does not update budget with invalid params" do
      put :update, :id => @budgets_of_psi_at_1002.to_param, :budget => {:hours => 'a'}, :project_id => @psi.to_param
      response.should be_success
      assigns[:budget].should == @budgets_of_psi_at_1002
      @budgets_of_psi_at_1002.reload.hours.should == 12
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested budget" do
      xhr :delete, :destroy, :id => @budgets_of_psi_at_1002.to_param, :project_id => @psi.to_param
      response.should be_success

      lambda { @budgets_of_psi_at_1002.reload }.should raise_error(ActiveRecord::RecordNotFound)
      assigns(:budget).should == @budgets_of_psi_at_0912
    end
  end
end
