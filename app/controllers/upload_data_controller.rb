class UploadDataController < ApplicationController
  def index
    @upload_data = UploadData.new
  end

  def create
    begin
      UploadData.save(params[:upload_data])
      flash[:notice] = "File was uploaded successfully!"

    rescue Exceptions::NoFileError
      flash[:error] = "No file specified!"
    rescue Exceptions::InvalidFormatError
      flash[:error] = "Invalid file format!"
    rescue StandardError
      flash[:error] = "Error while parsing data!"
    ensure
      redirect_to :back
    end
  end

end
