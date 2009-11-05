class User < ActiveRecord::Base
  has_many :tasks
  has_many :budgets, :through => :task
  has_one :department_belonging
  has_one :department, :through => :department_belonging
  has_many :leaded_projects, :class_name => 'Project', :foreign_key => 'leader_id'

  validates_length_of :name, :within => 1..50

  acts_as_authentic

  def projects
    @projects ||= Project.scoped(
            :joins => {:budgets => :tasks}, :conditions => {:tasks => {:user_id => id}}, :group => 'projects.id',
            :select => 'projects.*, MIN(budgets.at) AS start_at, MAX(budgets.at) AS end_at, SUM(tasks.work_hours) AS work_hours'
    )
  end

  def department_id
    department.try(:id)
  end

  def department_id=(value)
    department_belonging.department_id = value
    department_belonging.leader = false
    department_belonging.save
  end
end
