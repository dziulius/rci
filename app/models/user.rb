class User < ActiveRecord::Base
  has_many :tasks
  has_many :budgets, :through => :tasks
  has_one :leaded_department, :class_name => 'Department', :foreign_key => 'leader_id'
  has_many :leaded_projects, :class_name => 'Project', :foreign_key => 'leader_id'
  belongs_to :department

  validates_length_of :name, :within => 1..50

  acts_as_authentic
end
