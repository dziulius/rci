class BudgetsController < ApplicationController
  def index
    @budgets = Budget.all :order => 'at DESC'
  end

end
