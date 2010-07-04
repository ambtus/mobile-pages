class RefetchesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    if @page.parts.blank?
      @page.fetch(params[:url])
    else
      @page.parts_from_urls(params[:url_list], true)
    end
    redirect_to read_url(@page), :alert => @page.errors[:url]
  end
end
