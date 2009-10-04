class Project < ActiveRecord::Base
  has_many :budgets
  belongs_to :user
end
