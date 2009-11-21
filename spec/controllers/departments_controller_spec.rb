require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe DepartmentsController do
  integrate_views
  before do
    build 'in_main_dep.admin_leads'
    login @admin
  end

  describe "GET index" do
    it "assigns all departments as @departments" do
      get :index
      response.should be_success
      assigns[:departments].should == [@main_dep]
    end
  end

  describe "GET show" do
    it "assigns the requested department as @department" do
      get :show, :id => @main_dep.to_param
      response.should be_success
      assigns[:department].should == @main_dep
    end
  end

  describe "GET new" do
    it "assigns a new department as @department" do
      get :new
      response.should be_success
      assigns[:department].should be_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested department as @department" do
      get :edit, :id => @main_dep.to_param
      response.should be_success
      assigns[:department].should == @main_dep
    end
  end

  describe "POST create" do
    it "create new department with valid params" do
      post :create, :department => {:name => 'New department'}
      response.should redirect_to(departments_path)
      flash[:notice].should == "Successfully added new department."
      assigns[:department].should_not be_new_record
    end

    it "should not create new department with invalid params" do
      post :create, :department => {}
      response.should be_success
      response.should render_template('new')
      assigns[:department].should be_new_record
    end
  end

  describe "PUT update" do
    it "updates the requested department with valid params" do
      put :update, :id => @main_dep.to_param, :department => {:name => "New name"}
      response.should redirect_to(department_path(@main_dep))
      flash[:notice].should == "Successfully updated information."
      assigns[:department].should == @main_dep
      assigns[:department].name.should == "New name"
    end

    it "does not update department with invalid params" do
      put :update, :id => @main_dep.to_param, :department => {:name => ""}
      response.should be_success
      response.should render_template('edit')
      assigns[:department].should == @main_dep
      @main_dep.reload.name.should == "main dep."
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested department" do
      delete :destroy, :id => @main_dep.to_param

      response.should redirect_to(departments_path)
    end
  end
end
