class Department < ActiveRecord::Base
  has_many :department_belongings
  has_many :users, :through => :department_belongings
  has_one :leader, :through => :department_belongings, :conditions => 'department_belongings.leader = 1', :source => :user

  validates_presence_of :name
  validates_uniqueness_of :name

  using_access_control

  def leader_id
    leader.try(:id)
  end

  def leader_id=(value)
    transaction do
      if dp = department_belongings.first(:conditions => {:leader => true})
        dp.leader = false
        dp.save!
      end

      dp = department_belongings.first(:conditions => {:user_id => value})
      dp.leader = true
      dp.save!
    end
  end
end
