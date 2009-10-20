blueprint :users do
  @admin = User.blueprint(:name => 'admin', :email => 'admin@example.com', :password => 'secret', :password_confirmation => 'secret')
  @jonas = User.blueprint(:name => 'jonas', :email => 'jonas@example.com', :password => 'secret', :password_confirmation => 'secret')
end

blueprint :projects => :users do
  @first_project = @admin.leaded_projects.blueprint(:name => 'first')
end

blueprint :budgets => :projects do
  @first_project_0910 = @first_project.budgets.blueprint(:at => Time.mktime(2009, 10), :hours => 130)
  @first_project_0911 = @first_project.budgets.blueprint(:at => Time.mktime(2009, 11), :hours => 142)
  @first_project_0912 = @first_project.budgets.blueprint(:at => Time.mktime(2009, 12), :hours => 128)
end

blueprint :tasks => [:budgets, :users] do
  @admin_first_project_0910 = @first_project_0910.tasks.blueprint(:work_hours => 75, :user => @admin)
  @admin_first_project_0911 = @first_project_0911.tasks.blueprint(:work_hours => 70, :user => @admin)
  @admin_first_project_0912 = @first_project_0912.tasks.blueprint(:work_hours => 68, :user => @admin)

  @jonas_first_project_0910 = @first_project_0910.tasks.blueprint(:work_hours => 68, :user => @jonas)
  @jonas_first_project_0911 = @first_project_0911.tasks.blueprint(:work_hours => 61, :user => @jonas)
  @jonas_first_project_0912 = @first_project_0912.tasks.blueprint(:work_hours => 60, :user => @jonas)
end