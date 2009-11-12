class UsersController < ApplicationController
  # GET /users
  # GET /users.xml
  def index
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @users, @budget, @real_hours = @project.users_and_budget(params[:date_from]..params[:date_to])
    else
      @users = User.all
    end

    respond_to do |format|
      format.html
      format.js { render :partial => 'projects/users'}
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = t('users.create.notice')
      redirect_to users_path
    else
      render :action => "new"
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      flash[:notice] = t('users.update.notice')
      redirect_to(@user)
    else
      render :action => "edit"
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(users_url)
  end
end
