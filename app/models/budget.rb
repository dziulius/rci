class Budget < ActiveRecord::Base
  has_many :tasks
  belongs_to :project

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
