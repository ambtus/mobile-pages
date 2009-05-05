class PagesController < ApplicationController
  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = "Page created."
      redirect_to @page and return
    end
  end
  def show
    @page = Page.find(params[:id])
  end
  def update
    @page = Page.find(params[:id])
    @page = @page.next if (params[:commit] == "Next")
    @page.remove_nodes(params[:nodes]) if params[:nodes]
    @page.update_attributes(params[:page])
    redirect_to @page
  end
end
