class TasksController < ApplicationController
  before_filter :load_parent

  def new
    @task = @budget.tasks.build
  end

  def create
    @task = @budget.tasks.build(params[:task])
    if @task.save
      flash[:notice] = t('tasks.create.flash')
    else
      render :action => 'new'
    end
  end

  def edit
    @task = @budget.tasks.find(params[:id])
  end

  def update
    @task = @budget.tasks.find(params[:id])
    if @task.update_attributes(params[:task])
      flash[:notice] = t('tasks.update.flash')
    else
      render :action => 'new'
    end
  end

  def destroy
    @task = @budget.tasks.find(params[:id])
    @task.destroy
  end

  protected

  def load_parent
    @budget = Budget.find(params[:budget_id])
  end
end
