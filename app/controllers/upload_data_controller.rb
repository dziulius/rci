class UploadDataController < ApplicationController
  def index
    @upload_data = UploadData.new
  end

  def create
    begin
      UploadData.save(params[:upload_data])
      flash[:notice] = t('upload_data.results.success')

    rescue Exceptions::NoFileError
      flash[:error] = t('upload_data.results.no_file')
    rescue Exceptions::InvalidFormatError
      flash[:error] = t('upload_data.results.invalid_format')
    rescue StandardError
      flash[:error] = t('upload_data.results.other_error')
    ensure
      redirect_to :back
    end
  end

end
