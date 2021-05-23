class UploadsController < ApplicationController
  # POST /uploads { upload: <File> }
  def create
    uploader = FileUploader.new
    uploader.store!(params[:upload])
    render json: { url: uploader.url }
  end
end