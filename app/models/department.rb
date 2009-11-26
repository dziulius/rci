class Department < ActiveRecord::Base
  has_many :department_belongings
  has_many :users, :through => :department_belongings
  has_one :leader, :through => :department_belongings, :conditions => 'department_belongings.leader = 1', :source => :user

  validates_presence_of :name
  validates_uniqueness_of :name

  using_access_control

  # -- DUMMY methods
  def start_at
    Date.current << 5
  end

  def end_at
    Date.current
  end
  # -- DUMMY methods

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

  def projects
    Project.scoped(:joins => {:leader => :department_belonging}, :conditions => {:department_belongings => {:department_id => id}})
  end

  def budgets
    Budget.scoped(:conditions => {:project_id => projects.collect {|p| p.id }}, :order => 'at DESC')
  end

  def users_with_work_hours
    project_ids = projects.collect {|p| p.id }
    users.all :joins => {:tasks => {:budget => :project}}, :group => 'users.id',
              :select => "users.*, SUM(tasks.work_hours) AS work_hours, SUM(IF(projects.id IN (#{project_ids * ','}), tasks.work_hours,
                          0)) AS own_work_hours, MIN(budgets.at) AS start_at, MAX(budgets.at) AS end_at"
  end
end
