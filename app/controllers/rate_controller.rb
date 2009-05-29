class RateController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    date = @page.set_read_after(params[:commit])
    flash[:notice] = "Page set for reading again on #{date.to_date}"
    redirect_to root_url
  end
end
