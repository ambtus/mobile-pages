class RefetchController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    @page.fetch(params[:url])
    redirect_to @page
  end
end
