class Project < ActiveRecord::Base
  has_many :budgets
  belongs_to :leader, :class_name => 'User', :foreign_key => 'leader_id'

  validates_presence_of :name

  def to_s
    name
  end

  def start_at
    Time.parse(self['start_at'])
  end

  def end_at
    Time.parse(self['end_at'])
  end

  def work_hours
    self['work_hours'].to_i
  end
end
