class Task < ActiveRecord::Base
  belongs_to :budget
  belongs_to :user

  validates_presence_of :user, :budget, :work_hours
  validates_numericality_of :work_hours

  delegate :at_string, :to => :budget

  using_access_control

  def after_create
    user.update_attribute(:created_at, budget.at) if user.created_at > budget.at
  end
end
