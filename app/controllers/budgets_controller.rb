class BudgetsController < ApplicationController
  before_filter :load_parent, :except => :index

  def index
    if params[:user_id]
      @budgets = User.find_by_id(params[:user_id]).budgets.all
    elsif params[:department_id]
      @collection = if (@department = Department.find_by_id(params[:department_id]))
        @department.users
      else
        User.all
      end.collect{|user| {:val => user.id, :caption => user.name}}
      @collection = ([{:val => 0, :caption => t("support.select.all")}] + @collection).to_json
    elsif params[:project_id]
      load_parent
      @budgets = @project.budgets.all
      @budget = @budgets.first
    else
      @budgets = Budget.all
    end
    respond_to do |format|
      format.html{}
      format.js{render :partial => 'departments/budgets_table'}
      format.json{render :json => @collection}
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
