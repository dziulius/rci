require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UploadData do
  it "should validate presence of file to be uploaded" do
    file = mock(:instance_of? => Tempfile)
    lambda {
      UploadData.validates_file_presence({:data_file => file})
    }.should_not raise_error
  end

  it "should raise error in file presence validation with invalid params" do
    lambda {
      UploadData.validates_file_presence(nil)
    }.should raise_error Exceptions::NoFileError
    lambda {
      UploadData.validates_file_presence({})
    }.should raise_error Exceptions::NoFileError
    lambda {
      UploadData.validates_file_presence({:data_file => "file"})
    }.should raise_error Exceptions::NoFileError
  end

  it "should create 'tmp/uploaded' & 'tmp/csv' directories" do
    File.expects(:directory?).with('tmp/uploads').returns false
    File.expects(:directory?).with('tmp/csv').returns false
    Dir.expects(:mkdir).with('tmp/uploads')
    Dir.expects(:mkdir).with('tmp/csv')
    UploadData.create_directories
  end

  it "should validate uploaded file format" do
    file = mock()
    File.expects(:new).returns file
    file.expects(:read).with(4).returns "PK\003\004"
    file.expects(:close)
    lambda {
      UploadData.validates_xlsx_format("file.xlsx")
    }.should_not raise_error
  end

  it "should raise error if uploaded file format is incorrect" do
    file = mock()
    File.expects(:new).returns file
    file.expects(:read).with(4).returns "Fail"
    file.expects(:close)
    lambda {
      UploadData.validates_xlsx_format("file.xlsx")
    }.should raise_error Exceptions::InvalidFormatError
  end

  it "should save uploaded file to tmp/uploads" do
    name = "file.xlsx"
    tmp_file = mock(:original_filename => name, :read => "ABC")
    new_file = mock()
    File.expects(:open).yields new_file
    new_file.expects(:write)
    UploadData.save_file(tmp_file).should == File.join("tmp/uploads/", name)
  end

  it "should raise error in save_file method with invalid parameters" do
    lambda {
      UploadData.save_file("file")
    }.should raise_error NoMethodError
  end

  it "should return csv file name when invoked csv_file method" do
    names = %w{task project user department budget}
    0.upto(4) { |i|
      UploadData.csv_file(i).should == File.join("tmp/csv", names[i])
    }
  end

  it "should parse uploaded excel file to csv files" do
    file_name = "file.xlsx"
    new_file = mock()
    sheet = mock()
    Excelx.expects(:new).with(file_name).returns sheet
    0.upto(4) do |nr|
      name = UploadData.csv_file(nr)
      sheet.expects(:default_sheet=).with(nr+1)
      sheet.expects(:to_csv).with(name)
      csv = mock(:shift)
      File.expects(:readlines).with(name).returns csv
      File.expects(:open).with(name, 'w').yields new_file
      new_file.expects(:print).with(csv)
    end
    UploadData.parse_excel(file_name)
  end

  it "should create users and departments from csv files" do
    dep_row  = ["1", "Albinas"]
    user_row = ["Albinas", "1"]
    FasterCSV.expects(:foreach).with(UploadData.csv_file(3)).yields dep_row
    FasterCSV.expects(:foreach).with(UploadData.csv_file(2)).yields user_row

    department = mock()
    department.expects(:name=).with("1")
    Department.expects(:create).yields department
    department_last = mock()
    Department.expects(:last).returns department_last

    
    user = mock("user",:password= => nil, :password_confirmation= => nil, :department => department)
    user.expects(:name=).with("Albinas")
    user.expects(:department=).with(department_last)
    User.expects(:create).yields(user).returns user

    department.expects(:leader_id=).with(user)
    UploadData.create_users_departments
  end

  it "should create projects, budgets and departments from csv files" do
    proj_row = ["2000", "Bronius"]
    bud_row  = ["2000", "2009", "11", "500"]
    task_row = ["2000", "Bronius", "2009", "11", "300"]
    FasterCSV.expects(:foreach).with(UploadData.csv_file(1)).yields proj_row
    FasterCSV.expects(:foreach).with(UploadData.csv_file(4)).yields bud_row
    FasterCSV.expects(:foreach).with(UploadData.csv_file(0)).yields task_row

    user = mock()
    User.expects(:find_by_name).with("Bronius").times(2).returns user

    project = mock()
    project.expects(:name=).with("2000")
    project.expects(:leader=).with(user)
    Project.expects(:create).yields project
    project_last = mock()
    Project.expects(:last).returns project_last

    budget = mock()
    budget.expects(:at=).with(Date.new(2009, 11))
    budget.expects(:hours=).with(500)
    budget.expects(:project=).with(project_last)
    Budget.expects(:create).yields budget
    budget_last = mock()
    Budget.expects(:last).returns budget_last

    task = mock()
    task.expects(:work_hours=).with(300)
    task.expects(:budget=).with(budget_last)
    task.expects(:user=).with(user)
    Task.expects(:create).yields task

    UploadData.create_projects_budgets_tasks
  end
end
