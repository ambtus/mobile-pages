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
  def create
    @page = Page.find(params[:page_id])
    title = params[:title]
    @page.update_attribute(:title, title) if title && title != @page.title
    url_list = params[:url_list]
    if url_list != @page.url_list
      @page.parts_from_urls(params[:url_list]) 
    end
    if params[:add_parent] && params[:add_parent] != NEW_PARENT_TITLE && params[:add_parent] != @page.parent.try(:title)
      @page = @page.add_parent(params[:add_parent])
      case @page
        when "ambiguous"
           flash[:error] = "More than one page with that title"
           @page = Page.find(params[:page_id])
        when Page
           flash[:notice] = "Page added to this parent"
        else
           flash[:error] = "Parent with that title has content"
           @page = Page.find(params[:page_id])
      end
    end
    redirect_to page_path(@page)
  end
end
