class ChangeBudgetMonthYearToDate < ActiveRecord::Migration
  def self.up
    add_column :budgets, :at, :date 
    remove_column :budgets, :year
    remove_column :budgets, :month
  end

  def self.down
    remove_column :budgets, :at
    add_column :budgets, :year, :integer
    add_column :budgets, :month, :integer
  end
end
