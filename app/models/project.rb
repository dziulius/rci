class Project < ActiveRecord::Base
  has_many :budgets
  belongs_to :leader, :class_name => 'User', :foreign_key => 'leader_id'

  using_access_control

  validates_presence_of :name

  delegate :department, :to => :leader

  def to_s
    name
  end

  def start_at
    budgets.first(:order => 'at').try(:at)
  end

  def end_at
    budgets.first(:order => 'at DESC').try(:at).try(:end_of_month)
  end

  def work_hours
    self['work_hours'].to_i
  end

  def department_id
    DepartmentBelonging.first(:conditions => {:user_id => self.leader_id}).try(:department_id)
  end

  def own_work_hours
    @own_work_hours ||= Task.all(
      :joins => "JOIN budgets ON (tasks.budget_id = budgets.id) JOIN department_belongings ON (tasks.user_id = department_belongings.user_id)",
      :conditions => ["budgets.project_id = ? AND department_belongings.department_id = ?", id, department_id]
    ).try(:inject, 0){|sum, i| sum + i.work_hours}.to_i
  end
  
  def foreign_work_hours
    @foreign_work_hours ||= Task.all(
      :conditions => ['budgets.project_id = ? AND department_belongings.department_id <> ?', id, department_id],
      :joins => 'JOIN budgets ON (tasks.budget_id = budgets.id) JOIN department_belongings ON (department_belongings.user_id = tasks.user_id)'
    ).try(:inject, 0){|sum, i| sum + i.work_hours}.to_i
  end

  def users
    @users ||= User.scoped(
      :joins => 'LEFT JOIN tasks ON tasks.user_id = users.id JOIN budgets ON tasks.budget_id = budgets.id',
      :group => 'users.id', :select => 'users.*, SUM(tasks.work_hours) AS work_hours', :conditions => ['budgets.project_id = ?', id]
    )
  end

  def users_and_budget(between = nil)
    conditions = between ? {:budgets => {:at => Date.parse(between.first)..Date.parse(between.last)}} : {}
    usr = users.all(:conditions => conditions)
    [usr, budgets.sum('hours', :conditions => conditions), usr.sum(&:work_hours)]
  end

  def budgets_with_hours
    budgets.all(:joins => 'LEFT JOIN tasks ON tasks.budget_id = budgets.id', :order => 'at DESC', :group => 'budgets.id',
      :select => 'budgets.*, SUM(tasks.work_hours) AS used')
  end

  extend ActiveSupport::Memoizable
  memoize :start_at, :end_at
end
