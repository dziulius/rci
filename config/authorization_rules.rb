authorization do
  role :quest do
    has_permission_on [:user_sessions], :to => :manage
  end

  role :employee do # darbuotojas
    includes :quest
    has_permission_on [:budgets, :tasks, :projects], :to => :read
  end

  role :project_manager do # projekto vadovas
    includes :employee
    has_permission_on :projects, :to => :update
    has_permission_on :tasks , :to => :manage
  end

  role :department_head do # skyriaus vadovas
    includes :project_manager
    has_permission_on [:tasks, :projects, :department_belongings], :to => :manage
    has_permission_on :users, :to => [:read, :update]
    has_permission_on :departmets, :to => [:read, :update]
  end

  role :company_head do # firmos vadovas
    includes :project_manager
    has_permission_on [:budgets, :users, :departments], :to => :manage
  end

  role :admin do # adminas
    has_permission_on [:budgets, :projects, :tasks, :users, :department_belongings, :departments], :to => :manage
    has_permission_on :authorization_rules, :to => [:read, :update]
    has_permission_on :authorization_usages, :to => :read
  end
end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end