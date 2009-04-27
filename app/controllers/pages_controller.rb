class PagesController < ApplicationController
  def create
    @page = Page.new(params[:page])
    @page.save
    flash[:notice] = "Page created."
    redirect_to @page
  end
  def show
    @page = Page.find(params[:id])
  end
end
