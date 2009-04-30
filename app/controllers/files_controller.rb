class FilesController < ApplicationController
  class BadEnvironmentError < StandardError
  end

  def show
    case Rails.env
      when "test", "development"
        raise BadEnvironmentError unless params[:environment] == Rails.env
      when "production"
        raise BadEnvironmentError unless params[:environment] == "files"
    end

    @page = Page.find(params[:id])
    send_file(@page.mobile_file, :type => 'text/plain; charset=utf-8')

  rescue BadEnvironmentError
    logger.warn("#{Time.now} - environment mismatch: #{params.inspect}")
    render :text => "Error 400: Bad Request, environment mismatch", :status => 400
  end
end
