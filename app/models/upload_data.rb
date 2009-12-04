class UploadData
  class << self

    def save(uploaded_data)
      validates_file_presence(uploaded_data)
      create_directories
      xlsx_file = save_file(uploaded_data[:data_file])
      validates_xlsx_format(xlsx_file)
      parse_excel(xlsx_file)
      create_users_departments
      create_projects_budgets_tasks
    end

    def validates_file_presence(uploaded_data)
      if uploaded_data.nil? || !(uploaded_data[:data_file].instance_of? Tempfile)
        raise Exceptions::NoFileError
      end
    end

    def makedir(name)
      Dir.mkdir(name) unless File.directory?(name)
    end

    def create_directories
      makedir "tmp/uploads"
      makedir "tmp/csv"
    end

    def validates_xlsx_format(data_file)
      file = File.new(data_file, "r")
      bytes = file.read(4)
      file.close
      if bytes != "PK\003\004"
        raise Exceptions::InvalidFormatError
      end
    end

    def save_file(data_file)
      xlsx_file = File.join("tmp/uploads", data_file.original_filename)
      File.open(xlsx_file, "wb") { |f| f.write(data_file.read) }
      xlsx_file
    end

    def parse_excel(xlsx_file)
      sheet = Excelx.new(xlsx_file)
      0.upto(4) do |nr|
        sheet.default_sheet = nr + 1
        name = csv_file(nr)
        sheet.to_csv(name)
        csv_data = File.readlines(name)
        csv_data.shift
        File.open(name, "w") { |file| file.print csv_data }
      end
    end

    def create_users_departments
      FasterCSV.foreach(csv_file(3)) do |dep_row|
        Department.create do |depart|
          depart.name = dep_row[0]
        end
        department_last = Department.last
        FasterCSV.foreach(csv_file(2)) do |user_row|
          if user_row[1] == dep_row[0]
            user = User.create do |user|
              user.name = user_row[0]
              user.password = user.password_confirmation = rand(0).to_s
              user.department = department_last
            end
            user.department.leader_id = user if user_row[0] == dep_row[1]
          end
        end
      end
    end

    def create_projects_budgets_tasks
      FasterCSV.foreach(csv_file(1)) do |proj_row|
        Project.create do |project|
          project.name = proj_row[0]
          project.leader = User.find_by_name(proj_row[1])
        end
        project_last = Project.last
        FasterCSV.foreach(csv_file(4)) do |bud_row|
          if bud_row[0] == proj_row[0]
            Budget.create do |budget|
              budget.at = Date.new(bud_row[1].to_i, bud_row[2].to_i)
              budget.hours = bud_row[3].to_i
              budget.project = project_last
            end
            budget_last = Budget.last
            FasterCSV.foreach(csv_file(0)) do |task_row|
              if task_row[0] == bud_row[0] && task_row[2] == bud_row[1] &&
                task_row[3] == bud_row[2]
                Task.create do |task|
                  task.work_hours = task_row[4].to_i
                  task.budget = budget_last
                  task.user = User.find_by_name(task_row[1])
                end
              end
            end
          end
        end
      end
    end

    def csv_file(arg)
      names = %w{task project user department budget}
      csv_dir = "tmp/csv"
      File.join(csv_dir, names[arg])
    end

  end
end
