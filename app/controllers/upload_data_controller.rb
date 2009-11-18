class UploadDataController < ApplicationController
  def index
    @upload_data = UploadData.new
  end

  def create
    begin
      UploadData.save(params[:upload_data])
      flash[:notice] = "File was uploaded successfully!"
    rescue Exception => exception
      case exception.message
      when "no_file"
        msg = "No file specified!"
      when "invalid_format"
        msg = "Invalid file format!"
      else
        msg = "Error while parsing data!"
      end
      flash[:notice] = msg
    ensure
       redirect_to :back
    end
  end

end
