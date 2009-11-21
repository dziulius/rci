class Task < ActiveRecord::Base
  belongs_to :budget
  belongs_to :user

  delegate :at_string, :to => :budget

  using_access_control

end
