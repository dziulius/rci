require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  integrate_views

  describe "new login" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "login" do
    before do
      build :admin
    end

    it "should login with valid credentials" do
      post :create, :user_session => {:name => @admin.name, :password => 'secret'}
      response.flash[:notice].should == "Successfully logged in."
      response.should be_redirect
      response.should redirect_to(user_path(@admin))
      assigns(:user_session).user.should == @admin
    end

    it "should not login with invalid credentials" do
      post :create, :user_session => {:name => @admin.name, :password => 'wrong'}
      response.should be_success
      response.should render_template('user_sessions/new')
    end
  end

  describe "logout" do
    before do
      build :admin
      login @admin
    end

    it "should allow logging out" do
      delete :destroy
      response.flash[:notice].should == "Successfully logged out."
      response.should be_redirect
      response.should redirect_to(root_path)
      assigns(:user_session).user.should be_nil
    end
  end
end
