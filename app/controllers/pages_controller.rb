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
  def update
    @page = Page.find(params[:id])
    @page = @page.next if (params[:commit] == "Next")
    @page.remove_nodes(params[:nodes]) if params[:nodes]
    redirect_to @page
  end
end
