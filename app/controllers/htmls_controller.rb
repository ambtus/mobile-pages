class HtmlsController < ApplicationController
  def edit
    @page = Page.find(params[:id])
    if params[:format] == "scrubbed"
      render "scrubbed" and return
    end
  end

end
