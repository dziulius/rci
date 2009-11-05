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

  extend ActiveSupport::Memoizable
  memoize :start_at, :end_at
end
