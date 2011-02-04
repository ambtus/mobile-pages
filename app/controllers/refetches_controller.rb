class RefetchesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    if @page.parts.blank?
      @page.update_attribute(:url, params[:url])
      @page.fetch
    else
      @page.parts_from_urls(params[:url_list], true)
    end
    flash[:alert] == @page.errors[:url] unless @page.errors[:url].blank?
    redirect_to page_path(@page)
  end
end
