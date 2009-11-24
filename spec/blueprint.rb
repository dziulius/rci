Department.blueprint :main_dep, :name => 'main dep.'
Department.blueprint :second_dep, :name => 'second dep.'

#Role.blueprint(:admin, :title => "admin", :user => :@admin).depends_on(:admin)
#Role.blueprint(:andrius, :title => "admin", :user => :@andrius).depends_on(:andrius)
#Role.blueprint(:julius, :title => "admin", :user => :@julius).depends_on(:julius)

User.blueprint :admin, :name => 'admin', :password => 'secret', :password_confirmation => 'secret'
User.blueprint :andrius, :name => 'andrius', :password => 'secret', :password_confirmation => 'secret'
User.blueprint :julius, :name => 'julius', :password => 'secret', :password_confirmation => 'secret'

namespace :in_main_dep => :main_dep do
  DepartmentBelonging.blueprint(:admin_leads, :user => :@admin, :department => :@main_dep, :leader => true).depends_on(:admin)
  DepartmentBelonging.blueprint(:andrius_works, :user => :@andrius, :department => :@main_dep).depends_on(:andrius)
end

namespace :in_second_dep => :second_dep do
  DepartmentBelonging.blueprint(:julius_leads, :user => :@julius, :department => :@second_dep, :leader => true).
          depends_on(:julius)
end

Project.blueprint(:psi, :name => 'PSI', :leader => :@andrius).depends_on(:andrius)
Project.blueprint(:zks, :name => 'ZKS', :leader => :@admin).depends_on(:admin)
Project.blueprint(:julius_project, :name => 'Julius project', :leader => :@julius).depends_on(:julius)

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

namespace :budgets_of_julius_project => :julius_project do
  Budget.blueprint :at_0910, :at => Time.mktime(2009, 10), :hours => 113, :project => :@julius_project
  Budget.blueprint :at_0911, :at => Time.mktime(2009, 11), :hours => 114, :project => :@julius_project
end

namespace :tasks_of_julius_project => :budgets_of_julius_project do
  namespace :for_admin => :admin do
    Task.blueprint :at_0910, :work_hours => 82, :budget => :@budgets_of_julius_project_at_0910, :user => :@admin
    Task.blueprint :at_0911, :work_hours => 94, :budget => :@budgets_of_julius_project_at_0911, :user => :@admin
  end

  namespace :for_andrius => :andrius do
    Task.blueprint :at_0910, :work_hours => 100, :budget => :@budgets_of_julius_project_at_0910, :user => :@andrius
  end
end
