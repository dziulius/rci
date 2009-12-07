class User < ActiveRecord::Base
  has_many :tasks
  has_many :budgets, :through => :tasks
  has_one :department_belonging
  has_one :department, :through => :department_belonging
  has_many :leaded_projects, :class_name => 'Project', :foreign_key => 'leader_id'
  has_many :roles

  validates_length_of :name, :within => 1..50

  acts_as_authentic {|config| config.login_field :name }

  def role_symbols
    (roles || []).map {|r| r.title.to_sym}
  end

  def to_s
    name
  end

  def projects
    @projects ||= Project.scoped(
      :joins => {:budgets => :tasks}, :conditions => {:tasks => {:user_id => id}}, :group => 'projects.id',
      :select => 'projects.*, MIN(budgets.at) AS start_at, MAX(budgets.at) AS end_at, SUM(tasks.work_hours) AS work_hours'
    )
  end

  def work_hours
    @work_hours ||= self['work_hours'].to_i
  end

  def own_work_hours
    @own_work_hours ||= self['own_work_hours'].to_i
  end

  def foreign_work_hours
    work_hours - own_work_hours
  end

  def start_at
    Date.parse(self['start_at'])
  end

  def end_at
    Date.parse(self['end_at']).end_of_month
  end

  def work_days
    @work_days ||= start_at.work_days_between(end_at)
  end

  def lazy_hours
    work_days * 8 - work_hours
  end

  def department_id
    department.try(:id)
  end

  def department_id=(value)
    build_department_belonging unless department
    department_belonging.leader = false unless value.to_i == department_id
    department_belonging.department_id = value
    department_belonging.save
  end

  def tasks_for(project)
    tasks.all(:include => :budget, :conditions => {:budgets => {:project_id => project.id}}, :order => 'budgets.at DESC')
  end
end
