class Department < ActiveRecord::Base
  has_many :users
  belongs_to :leader, :class_name => 'User'
end
