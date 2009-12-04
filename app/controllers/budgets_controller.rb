class BudgetsController < ApplicationController
  before_filter :load_parent, :except => :index

  def index
    if params[:department_id]
      @department = Department.find(params[:department_id])
    elsif params[:project_id]
      load_parent
      @budgets = @project.budgets
      @budget = @budgets.first
    else
      @budgets = Budget.all
    end
    respond_to do |format|
      format.html
      format.js{render :partial => 'departments/budgets_table'}
    end
  end

  def new
    @budget = @project.budgets.build(:at => @project.budgets.first.at >> 1)
  end

  def create
    @budget = @project.budgets.build(params[:budget])
    if @budget.save
      flash[:notice] = t('budgets.create.flash')
    else
      render :action => 'new'
    end
  end

  def update
    @budget = @project.budgets.find(params[:id])
    if @budget.update_attributes(params[:budget])
      flash[:notice] = t('budgets.update.flash')
      render :action => 'create'
    else
      render :action => 'new'
    end
  end

  def destroy
    @project.budgets.destroy(params[:id])
    @budget = @project.budgets.first
    render :action => 'create'
  end

  protected

  def load_parent
    @project = Project.find(params[:project_id])
  end
end
