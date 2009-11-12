module ProjectsHelper
  def hours_worked(project)
    real_work = project.users.sum(&:work_hours)
    budget = project.budgets.sum('hours')
    
    color = if real_work < budget
      'orange'
    elsif real_work > budget
      'red'
    else
      'green'
    end

    content_tag('p', "Total hours worked: <span class='#{color}'>#{real_work}</span>/#{budget} (<span class='#{color}'>#{
            real_work * 100 / budget}%</span>)")
  end
end
