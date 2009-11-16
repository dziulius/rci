module ProjectsHelper
  def hours_worked(real_hours, budget)
    color = if real_hours < budget
      'orange'
    elsif real_hours > budget
      'red'
    else
      'green'
    end

    content_tag('p', "Total hours worked: <span class='#{color}'>#{real_hours}</span>/#{budget} (<span class='#{color}'>#{
            budget.zero? ? 0 : real_hours * 100 / budget}%</span>)")
  end
end
