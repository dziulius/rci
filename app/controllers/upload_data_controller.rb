class UploadDataController < ApplicationController
  def index
    @upload_data = UploadData.new
  end

  def create
    UploadData.save(params[:upload_data])
    flash[:notice] = "File was uploaded successfully!"
    redirect_to :back
  end

end
