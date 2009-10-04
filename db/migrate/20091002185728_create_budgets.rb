class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.integer :project_id
      t.integer :year
      t.integer :month
      t.integer :hours

      t.timestamps
    end
  end

  def self.down
    drop_table :budgets
  end
end
