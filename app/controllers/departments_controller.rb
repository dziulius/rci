class DepartmentsController < ApplicationController
  filter_resource_access
  # GET /departments
  # GET /departments.xml
  def index
    @departments = Department.all
  end

  # GET /departments/1
  # GET /departments/1.xml
  def show
    @department = Department.find(params[:id])
  end

  # GET /departments/new
  # GET /departments/new.xml
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
    @department = Department.find(params[:id])
  end

  # POST /departments
  # POST /departments.xml
  def create
    @department = Department.new(params[:department])

    if @department.save
      flash[:notice] = t('departments.create.notice')
      redirect_to departments_path
    else
      render :action => "new"
    end
  end

  # PUT /departments/1
  # PUT /departments/1.xml
  def update
    @department = Department.find(params[:id])

    if @department.update_attributes(params[:department])
      flash[:notice] = t('departments.update.notice')
      redirect_to(@department)
    else
      render :action => "edit"
    end
  end

  # DELETE /departments/1
  # DELETE /departments/1.xml
  def destroy
    @department = Department.find(params[:id])
    @department.destroy

    redirect_to(departments_url)
  end
end
