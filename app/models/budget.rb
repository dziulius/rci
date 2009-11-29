class Budget < ActiveRecord::Base
  has_many :tasks
  belongs_to :project

  default_scope :order => 'at DESC'

  validates_presence_of :project, :at, :hours
  validates_uniqueness_of :at, :scope => [:project_id]
  validates_numericality_of :hours

  using_access_control

  def at_string
    I18n.l at, :format => :long_year_month
  end

  def used
    self['used'].to_i
  end

  def remaining
    hours - used
  end
end
