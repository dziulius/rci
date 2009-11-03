class User < ActiveRecord::Base
  has_many :tasks
  has_many :budgets, :through => :task
  has_many :department_belongings
  has_one :department, :through => :department_belongings
  has_many :leaded_projects, :class_name => 'Project', :foreign_key => 'leader_id'

  validates_length_of :name, :within => 1..50

  acts_as_authentic

  def projects
    @projects ||= Project.scoped(
            :joins => {:budgets => :tasks}, :conditions => {:tasks => {:user_id => id}}, :group => 'projects.id',
            :select => 'projects.*, MIN(budgets.at) AS start_at, MAX(budgets.at) AS end_at, SUM(tasks.work_hours) AS work_hours'
    )
  end
end
