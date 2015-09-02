class RefetchesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    if @page.parts.blank? || @page.ao3?
      @page.update_attribute(:url, params[:url])
      if @page.ao3?
        @page.refetch_ao3
      else
        @page.fetch
      end
    else
      @page.parts_from_urls(params[:url_list], true)
    end
    flash[:alert] == @page.errors[:url] unless @page.errors[:url].blank?
    redirect_to page_path(@page)
  end
end
