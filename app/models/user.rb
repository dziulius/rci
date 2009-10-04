class User < ActiveRecord::Base
  has_many :tasks
  has_one :department
  has_one :project
  belongs_to :department

  validates_presence_of :name

  acts_as_authentic
end
