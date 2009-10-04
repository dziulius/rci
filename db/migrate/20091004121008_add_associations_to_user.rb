class AddAssociationsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :departament_id, :integer
  end

  def self.down
    remove_column :users, :departament_id
  end
end
