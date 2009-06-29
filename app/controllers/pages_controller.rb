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
    @page = @page.next if (params[:commit] == "Read Later")
    if params[:commit] == "Make UTF8"
      if @page.parts.empty?
        @page.build_me("utf8")
      else
        @page.parts.each {|p| p.build_me("utf8")}
      end
    end
    if params[:commit] == "Update Raw HTML"
      @page.pasted = params[:pasted]
      flash[:notice] = "Raw HTML updated."
    end
    @page.remove_nodes(params[:nodes]) if params[:nodes]
    @page.update_attributes(params[:page])
    redirect_to @page
  end
end
