class Department < ActiveRecord::Base
  has_many :department_belongings
  has_many :users, :through => :department_belongings
  has_one :leader, :through => :department_belongings, :conditions => 'department_belongings.leader = 1', :source => :user 

  validates_presence_of :name
end
