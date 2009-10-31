class UploadData
  @names = %w{task project user department budget}
  @csv_dir = "tmp/csv"
  @xlsx_file = nil

  def self.save(uploaded)
    temp_file = uploaded[:data_file]
    @xlsx_file = File.join("tmp/uploads", temp_file.original_filename)
    File.open(@xlsx_file, "wb") { |f| f.write(temp_file.read) }

    sheet = Excelx.new(@xlsx_file)
    0.upto(4) do |nr|
      sheet.default_sheet = nr + 1
      name = csv_file(nr)
      sheet.to_csv(name)
      csv_data = File.readlines(name)
      csv_data.shift
      File.open(name, "w") { |file| file.print csv_data }
    end

    FasterCSV.foreach(csv_file(3)) do |dep_row|
      department_last = Department.new do |depart|
        depart.name = dep_row[0]
      end
      department_last.save
      department_last = Department.last
      FasterCSV.foreach(csv_file(2)) do |user_row|
        if user_row[1] == dep_row[0]
          user = User.new do |user|
            user.name = user_row[0]
            user.email = "#{user_row[0]}@system.local"
            user.password = rand(0).to_s
            user.department = department_last
          end
          user.save_with_validation(false)
          if user_row[0] == dep_row[1]
            department_last.leader = user
            department_last.save
          end
        end
      end
    end

    FasterCSV.foreach(csv_file(1)) do |proj_row|
      project_last = Project.new do |project|
        project.name = proj_row[0]
      end
      project_last.save
      project_last = Project.last
      FasterCSV.foreach(csv_file(4)) do |bud_row|
        if bud_row[0] == proj_row[0]
          budget_last = Budget.new do |budget|
            budget.at = Date.new(bud_row[1].to_i, bud_row[2].to_i)
            budget.hours = bud_row[3].to_i
            budget.project = project_last
          end
          budget_last.save
          budget_last = Budget.last
          FasterCSV.foreach(csv_file(0)) do |task_row|
            if task_row[0] == bud_row[0] && task_row[2] == bud_row[1] && task_row[3] == bud_row[2]
              task = Task.new do |task|
                task.work_hours = task_row[4].to_i
                task.budget = budget_last
                task.user = User.first(:conditions => { :name => task_row[1]})
              end
              task.save
            end
          end
        end
      end
    end
  end

  private

  def self.csv_file(arg)
    if arg.instance_of? Fixnum
      path = File.join(@csv_dir, @names[arg])
    else
      path = File.join(@csv_dir, arg)
    end
    path
  end

end
