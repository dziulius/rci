class Project < ActiveRecord::Base
  has_many :budgets
  belongs_to :leader, :class_name => 'User', :foreign_key => 'leader_id'
end
