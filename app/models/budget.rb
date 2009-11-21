class Budget < ActiveRecord::Base
  has_many :tasks
  belongs_to :project

  using_access_control

  def at_string
    at.to_formatted_s(:long_year_month)
  end

  def used
    self['used'].to_i
  end

  def remaining
    hours - used
  end

  def remaining_percent
    ((remaining.to_f / hours) * 10000).round / 100.0
  end
end
