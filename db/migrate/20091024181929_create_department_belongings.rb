class CreateDepartmentBelongings < ActiveRecord::Migration
  def self.up
    remove_column :users, :department_id
    remove_column :departments, :leader_id
    create_table :department_belongings do |t|
      t.belongs_to :department
      t.belongs_to :user
      t.boolean :leader
      t.datetime :created_at
    end
  end

  def self.down
    add_column :users, :department_id, :integer
    add_column :departments, :leader_id, :integer
    drop_table :department_belongings
  end
end
