class UploadData < ActiveRecord::Base
  has_no_table

  validates_presence_of :data_file

  attr_reader :xlsx_file
  column :data_file

  def save
    return unless valid?
    create_directories
    save_file
    validates_xlsx_format
    spawn do
      begin
        parse_excel
        users = create_users_departments
        create_projects_budgets_tasks
      ensure
        mail = AdminMailer.create_password_list(users)
        AdminMailer.deliver(mail)
      end
    end
    true
  end

  def makedir(name)
    Dir.mkdir(name) unless File.directory?(name)
  end

  def create_directories
    makedir "tmp/uploads"
    makedir "tmp/csv"
  end

  def validates_xlsx_format
    file = File.new(self.xlsx_file, "r")
    bytes = file.read(4)
    file.close
    if bytes != "PK\003\004"
      raise Exceptions::InvalidFormatError
    end
  end

  def save_file
    @xlsx_file = File.join("tmp/uploads", self.data_file.original_filename)
    File.open(@xlsx_file, "wb") { |f| f.write(self.data_file.read) }
  end

  def parse_excel
    sheet = Excelx.new(@xlsx_file)
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
    users = []
    FasterCSV.foreach(csv_file(3)) do |dep_row|
      Department.create do |depart|
        depart.name = dep_row[0]
      end
      department_last = Department.last
      FasterCSV.foreach(csv_file(2)) do |user_row|
        if user_row[1] == dep_row[0]
          user = User.create do |user|
            user.name = user_row[0]
            password = Kernel.rand.to_s
            user.password = user.password_confirmation = password
            user.department = department_last
            users << { :name => user_row[0], :password => password }
          end
          user.department.leader_id = user if user_row[0] == dep_row[1]
        end
      end
    end
    users
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
