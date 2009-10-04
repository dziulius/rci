class User < ActiveRecord::Base
  has_many :tasks
  has_one :department
  has_one :project
  belongs_to :department

  validates_length_of :name, :within => 1..50

  acts_as_authentic
end
