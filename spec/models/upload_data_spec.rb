require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe @upload_data do
  before :each do
    @upload_data = UploadData.new
  end
  it "should create 'tmp/uploaded' & 'tmp/csv' directories" do
    File.expects(:directory?).with('tmp/uploads').returns false
    File.expects(:directory?).with('tmp/csv').returns false
    Dir.expects(:mkdir).with('tmp/uploads')
    Dir.expects(:mkdir).with('tmp/csv')
    @upload_data.create_directories
  end

  it "should validate uploaded file format" do
    file = mock()
    File.expects(:new).returns file
    file.expects(:read).with(4).returns "PK\003\004"
    file.expects(:close)
    lambda {
      @upload_data.validates_xlsx_format
    }.should_not raise_error
  end

  it "should raise error if uploaded file format is incorrect" do
    file = mock()
    File.expects(:new).returns file
    file.expects(:read).with(4).returns "Fail"
    file.expects(:close)
    lambda {
      @upload_data.validates_xlsx_format
    }.should raise_error Exceptions::InvalidFormatError
  end

  it "should save uploaded file to tmp/uploads" do
    name = "file.xlsx"
    tmp_file = mock(:original_filename => name, :read => "ABC")
    new_file = mock()
    File.expects(:open).yields new_file
    new_file.expects(:write)
    @upload_data.data_file = tmp_file
    @upload_data.save_file
    @upload_data.xlsx_file.should == File.join("tmp/uploads/", name)
  end

  it "should raise error in save_file method with invalid parameters" do
    lambda {
      @upload_data.save_file
    }.should raise_error NoMethodError
  end

  it "should return csv file name when invoked csv_file method" do
    names = %w{task project user department budget}
    0.upto(4) { |i|
      @upload_data.csv_file(i).should == File.join("tmp/csv", names[i])
    }
  end

  it "should parse uploaded excel file to csv files" do
    file_name = "file.xlsx"
    new_file = mock()
    name = @upload_data.instance_variable_set(:@xlsx_file, file_name)
    sheet = mock()
    Excelx.expects(:new).with(file_name).returns sheet
    0.upto(4) do |nr|
      name = @upload_data.csv_file(nr)
      sheet.expects(:default_sheet=).with(nr+1)
      sheet.expects(:to_csv).with(name)
      csv = mock(:shift)
      File.expects(:readlines).with(name).returns csv
      File.expects(:open).with(name, 'w').yields new_file
      new_file.expects(:print).with(csv)
    end
    @upload_data.parse_excel
  end

  it "should create users and departments and return array of users" do
    dep_row  = ["1", "Albinas"]
    user_row = ["Albinas", "1"]
    FasterCSV.expects(:foreach).with(@upload_data.csv_file(3)).yields dep_row
    FasterCSV.expects(:foreach).with(@upload_data.csv_file(2)).yields user_row
    Kernel.stubs(:rand).returns 0.12345678

    department = mock()
    department.expects(:name=).with("1")
    Department.expects(:create).yields department
    department_last = mock()
    Department.expects(:last).returns department_last

    
    user = mock(:department => department)
    user.expects(:name=).with("Albinas")
    user.expects(:password=).with "0.12345678"
    user.expects(:password_confirmation=)
    user.expects(:department=).with(department_last)
    User.expects(:create).yields(user).returns user

    department.expects(:leader_id=).with(user)
    @upload_data.create_users_departments.should ==
      [{ :name => "Albinas", :password => "0.12345678" }]
  end

  it "should create projects, budgets and departments from csv files" do
    proj_row = ["2000", "Bronius"]
    bud_row  = ["2000", "2009", "11", "500"]
    task_row = ["2000", "Bronius", "2009", "11", "300"]
    FasterCSV.expects(:foreach).with(@upload_data.csv_file(1)).yields proj_row
    FasterCSV.expects(:foreach).with(@upload_data.csv_file(4)).yields bud_row
    FasterCSV.expects(:foreach).with(@upload_data.csv_file(0)).yields task_row

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

    @upload_data.create_projects_budgets_tasks
  end

  it "should call all methods needed to save data in save method" do
    xlsx_file = mock()
    @upload_data.expects(:data_file => "file")
    @upload_data.expects(:create_directories)
    @upload_data.expects(:save_file)
    @upload_data.expects(:validates_xlsx_format)
    @upload_data.expects(:spawn)
    #    @upload_data.expects(:create_users_departments).returns users
    #    @upload_data.expects(:create_projects_budgets_tasks)
    @upload_data.save.should be_true
  end
end
