class HtmlsController < ApplicationController
  def edit
    @page = Page.find(params[:id])
  end
end
