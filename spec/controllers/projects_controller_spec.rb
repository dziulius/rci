require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do
  integrate_views
  before do
    build :psi, :admin
    login @admin
  end

  describe "GET index" do
    it "assigns all projects as @projects" do
      get :index
      response.should be_success
      assigns[:projects].should == [@psi]
    end
  end

  describe "GET show" do
    it "assigns the requested project as @project" do
      build 'tasks.of_psi', :in_main_dep
      get :show, :id => @psi.to_param
      response.should be_success
      assigns[:project].should == @psi
      assigns[:users].should == [@andrius, @admin]
      assigns[:budget].should == 411
      assigns[:real_hours].should == 404
    end
  end

  describe "GET new" do
    it "assigns a new project as @project" do
      get :new
      response.should be_success
      assigns[:project].should be_new_record
    end
  end

  describe "GET edit" do
    it "assigns the requested project as @project" do
      get :edit, :id => @psi.to_param
      response.should be_success
      assigns[:project].should == @psi
    end
  end

  describe "POST create" do
    it "create new project with valid params" do
      post :create, :project => {:name => 'New project', :leader_id => @admin.id}
      response.should redirect_to(projects_path)
      flash[:notice].should == "Successfully added new project."
      assigns[:project].should_not be_new_record
    end

    it "should not create new project with invalid params" do
      post :create, :project => {}
      response.should be_success
      response.should render_template('new')
      assigns[:project].should be_new_record
    end
  end

  describe "PUT update" do
    it "updates the requested project with valid params" do
      put :update, :id => @psi.to_param, :project => {:name => "New name"}
      response.should redirect_to(project_path(@psi))
      flash[:notice].should == "Successfully updated information."
      assigns[:project].should == @psi
      assigns[:project].name.should == "New name"
    end

    it "does not update project with invalid params" do
      put :update, :id => @psi.to_param, :project => {:name => ""}
      response.should be_success
      response.should render_template('edit')
      assigns[:project].should == @psi
      @psi.reload.name.should == "PSI"
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested project" do
      delete :destroy, :id => @psi.to_param
      response.should redirect_to(projects_path)
    end
  end
end
