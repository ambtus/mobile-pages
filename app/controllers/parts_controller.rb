class PartsController < ApplicationController
  NEW_PARENT_TITLE = "Enter the title of the desired Parent Page"
  def new
    @new_page = Page.new
    @title = "New parent page"
  end
  def edit
    @page = Page.find(params[:id])
    @title = "Edit parts for #{@page.title}"
    if @page.parent
      @parent_title = @page.parent.title
    else
      @parent_title = NEW_PARENT_TITLE
    end
  end
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:url_list] && params[:url_list] != ( "#" + @page.title )
      @page.parts_from_urls(params[:url_list]) 
    end
    if params[:add_parent] && params[:add_parent] != NEW_PARENT_TITLE
      @page = @page.add_parent(params[:add_parent])
      if @page == false
        flash[:error] = "Couldn't find or create parent"
        @page = Page.find(params[:page_id])
      end
    end
    redirect_to part_path(@page)
  end
end
