class UploadDataController < ApplicationController
  def index
    @upload_data = UploadData.new
  end

  def create
    begin
      upload_data = UploadData.new(params[:upload_data])
      if upload_data.save
        flash[:notice] = t('upload_data.results.success')
      else
        flash[:error] = t('upload_data.results.no_file')
      end
    rescue Exceptions::InvalidFormatError
      flash[:error] = t('upload_data.results.invalid_format')
    rescue StandardError
      flash[:error] = t('upload_data.results.other_error')
    ensure
      redirect_to :back
    end
  end

end
