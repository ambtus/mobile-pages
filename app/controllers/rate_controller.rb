class RateController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    page = Page.find(params[:page_id])
    page.update_rating(params[:commit])
    flash[:notice] = "#{page.title} set for reading again on #{page.read_after}"
    redirect_to pages_url
  end
end
