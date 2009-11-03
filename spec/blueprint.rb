Department.blueprint :main_dep, :leader => :@admin, :name => 'main dep.'

User.blueprint :admin, :name => 'admin', :email => 'admin@example.com', :password => 'secret', :password_confirmation => 'secret'
User.blueprint :andrius, :name => 'andrius', :email => 'andrius@example.com', :password => 'secret',
               :password_confirmation => 'secret'

DepartmentBelonging.blueprint(:admin_leads_main_dep, :user => :@admin, :department => :@main_dep, :leader => true).depends_on(
        :main_dep, :admin)

Project.blueprint(:psi, :name => 'PSI', :leader => :@andrius).depends_on(:andrius)
Project.blueprint(:zks, :name => 'ZKS', :leader => :@admin).depends_on(:admin)

namespace :budgets do
  namespace :of_psi => :psi do
    Budget.blueprint :at_0910, :at => Time.mktime(2009, 10), :hours => 130, :project => :@psi
    Budget.blueprint :at_0911, :at => Time.mktime(2009, 11), :hours => 142, :project => :@psi
    Budget.blueprint :at_0912, :at => Time.mktime(2009, 12), :hours => 127, :project => :@psi
    Budget.blueprint :at_1002, :at => Time.mktime(2010, 2), :hours => 12, :project => :@psi
  end

  namespace :of_zks => :zks do
    Budget.blueprint :at_0911, :at => Time.mktime(2009, 11), :hours => 78, :project => :@zks
  end
end

namespace :tasks do
  namespace :of_psi => 'budgets.of_psi' do
    namespace :for_admin => :admin do
      Task.blueprint :at_0910, :work_hours => 72, :budget => :@budgets_of_psi_at_0910, :user => :@admin
      Task.blueprint :at_0911, :work_hours => 65, :budget => :@budgets_of_psi_at_0911, :user => :@admin
      Task.blueprint :at_0912, :work_hours => 63, :budget => :@budgets_of_psi_at_0912, :user => :@admin
      Task.blueprint :at_1002, :work_hours => 13, :budget => :@budgets_of_psi_at_1002, :user => :@admin
    end

    namespace :for_andrius => :andrius do
      Task.blueprint :at_0910, :work_hours => 66, :budget => :@budgets_of_psi_at_0910, :user => :@andrius
      Task.blueprint :at_0911, :work_hours => 61, :budget => :@budgets_of_psi_at_0911, :user => :@andrius
      Task.blueprint :at_0912, :work_hours => 64, :budget => :@budgets_of_psi_at_0912, :user => :@andrius
    end
  end

  namespace :of_zks => 'budgets.of_zks' do
    namespace :for_andrius => :andrius do
      Task.blueprint :at_0911, :work_hours => 61, :budget => :@budgets_of_zks_at_0911, :user => :@andrius
    end
  end
end
