class User < ActiveRecord::Base
  validates_presence_of :name

  acts_as_authentic
end