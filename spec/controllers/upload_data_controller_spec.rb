require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UploadDataController do
  integrate_views
  before do
    build :admin
    login @admin
  end

  describe "GET index" do
    it "assigns new UploadData object as @upload_data" do
      get :index
      assigns[:upload_data].should be_instance_of UploadData
      response.should be_success
    end
  end

  describe "POST create" do
    before :each do
      @request.env['HTTP_REFERER'] = upload_data_path
    end

    it "should upload data with valid parameters" do
      UploadData.expects(:save)
      post :create 
      flash[:notice].should == "File was uploaded successfully!"
    end

    it "should print corresponding message to NoFileError exception" do
      UploadData.expects(:save).raises Exceptions::NoFileError
      post :create 
      flash[:error].should == "No file specified!"
    end

    it "should print corresponding message to InvalidFormatError" do
      UploadData.expects(:save).raises Exceptions::InvalidFormatError
      post :create 
      flash[:error].should == "Invalid file format!"
    end

    it "should print corresponding error message to other exceptions" do
      UploadData.expects(:save).raises StandardError
      post :create 
      flash[:error].should == "Error while parsing data!"
    end

    after :each do
      response.should redirect_to(upload_data_path)
    end
  end
end
