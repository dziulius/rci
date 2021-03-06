class ProjectsController < ApplicationController
  filter_resource_access
  # GET /projects
  # GET /projects.xml
  def index
    respond_to do |format|
      if params[:department_id]
        @department = Department.find(params[:department_id])
      else
        @projects = current_user.projects.all
      end
      format.html
      format.js{render :partial => "departments/projects_table"}
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    if @project.leader == (@user = current_user)
      @users, @budget, @real_hours = @project.users_and_budget if params[:tab] == 'workers'
    else
      @tasks = @user.tasks_for(@project)
    end

    render_tabs(:workers, :budgets)
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])

    if @project.save
      flash[:notice] = t('projects.create.notice')
      redirect_to projects_path
    else
      render :action => "new"
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      flash[:notice] = t('projects.update.notice')
      redirect_to(@project)
    else
      render :action => "edit"
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    redirect_to(projects_url)
  end
end
