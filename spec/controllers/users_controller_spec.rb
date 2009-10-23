require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  integrate_views
  before do
    build :admin
    login @admin
  end

  describe "GET index" do
    it "assigns all users as @users" do
      get :index
      response.should be_success
      assigns[:users].should == [@admin]
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      get :show, :id => @admin.to_param
      response.should be_success
      assigns[:user].should == @admin
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new
      response.should be_success
      assigns[:user].should be_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      get :edit, :id => @admin.to_param
      response.should be_success
      assigns[:user].should == @admin
    end
  end

  describe "POST create" do
    it "create new user with valid params" do
      post :create, :user => {:name => 'New user', :password => 'secret', :password_confirmation => 'secret', :email => 'new_user@example.com'}
      response.should redirect_to(users_path)
      flash[:notice].should == "Successfully added new user."
      assigns[:user].should_not be_new_record
    end

    it "should not create new user with invalid params" do
      post :create, :user => {}
      response.should be_success
      response.should render_template('new')   
      assigns[:user].should be_new_record
    end
  end

  describe "PUT update" do
    it "updates the requested user with valid params" do
      put :update, :id => @admin.to_param, :user => {:name => "New name"}
      response.should redirect_to(user_path(@admin))
      flash[:notice].should == "Successfully updated information."
      assigns[:user].should == @admin
      assigns[:user].name.should == "New name"
    end

    it "does not update user with invalid params" do
      put :update, :id => @admin.to_param, :user => {:name => ""}
      response.should be_success
      response.should render_template('edit')
      assigns[:user].should == @admin
      @admin.reload.name.should == "admin"
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      delete :destroy, :id => @admin.to_param
      response.should redirect_to(users_path)
    end
  end
end
