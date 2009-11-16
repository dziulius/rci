class Project < ActiveRecord::Base
  has_many :budgets
  belongs_to :leader, :class_name => 'User', :foreign_key => 'leader_id'

  validates_presence_of :name
  
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
