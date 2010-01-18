class RateController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    page = Page.find(params[:page_id])
    page.set_read_after(params[:commit])
    flash[:notice] = "#{page.title} set for reading again on #{page.read_after}"
    redirect_to pages_url
  end
end
