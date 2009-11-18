blueprint :users do
  @admin = User.blueprint(:name => 'admin', :password => 'secret', :password_confirmation => 'secret')
  @jonas = User.blueprint(:name => 'jonas', :password => 'secret', :password_confirmation => 'secret')
end

blueprint :departments do
  @main_dep = Department.blueprint(:name => 'main dep.')
end

blueprint :department_belongings => [:departments, :users] do
  @admin_leads_main_dep = DepartmentBelonging.blueprint(:department => @main_dep, :user => @admin, :leader => true)
  @jonas_in_main_dep = DepartmentBelonging.blueprint(:department => @main_dep, :user => @jonas)
end

blueprint :projects => :users do
  @first_project = @admin.leaded_projects.blueprint(:name => 'first')
  @jonas_project = @jonas.leaded_projects.blueprint(:name => 'jonas project')
end

blueprint :budgets => :projects do
  @first_project_0910 = @first_project.budgets.blueprint(:at => Time.mktime(2009, 10), :hours => 130)
  @first_project_0911 = @first_project.budgets.blueprint(:at => Time.mktime(2009, 11), :hours => 142)
  @first_project_0912 = @first_project.budgets.blueprint(:at => Time.mktime(2009, 12), :hours => 128)

  @jonas_project_0912 = @jonas_project.budgets.blueprint(:at => Time.mktime(2009, 12), :hours => 54)
end

blueprint :tasks => [:budgets, :users] do
  @admin_first_project_0910 = @first_project_0910.tasks.blueprint(:work_hours => 75, :user => @admin)
  @admin_first_project_0911 = @first_project_0911.tasks.blueprint(:work_hours => 70, :user => @admin)
  @admin_first_project_0912 = @first_project_0912.tasks.blueprint(:work_hours => 68, :user => @admin)

  @jonas_first_project_0910 = @first_project_0910.tasks.blueprint(:work_hours => 68, :user => @jonas)
  @jonas_first_project_0911 = @first_project_0911.tasks.blueprint(:work_hours => 61, :user => @jonas)
  @jonas_first_project_0912 = @first_project_0912.tasks.blueprint(:work_hours => 60, :user => @jonas)

  @jonas_first_project_0912 = @jonas_project_0912.tasks.blueprint(:work_hours => 55, :user => @jonas)
end
