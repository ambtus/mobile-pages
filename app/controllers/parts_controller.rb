class PartsController < ApplicationController
  NEW_PARENT_TITLE = "Enter the title of the desired Parent Page"
  def new
    @new_page = Page.new
    @title = "New parent page"
  end
  def edit
    @page = Page.find(params[:id])
    if params[:add]
      @title = "Add part to #{@page.title}"
      render "add"
    else
      @title = "Edit parts for #{@page.title}"
      if @page.parent
        @parent_title = @page.parent.title
      else
        @parent_title = NEW_PARENT_TITLE
      end
    end
  end
  def create
    @page = Page.find(params[:page_id])
    title = params[:title]
    @page.update_attribute(:title, title) if title && title != @page.title
    if params[:add_url]
      @page.add_part(params[:add_url])
      flash[:notice] = "Part added"
      redirect_to page_path(@page) and return
    end
    url_list = params[:url_list]
    if url_list != @page.url_list
      @page.parts_from_urls(params[:url_list])
      flash[:alert] = @page.errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    end
    if params[:add_parent] && params[:add_parent] != NEW_PARENT_TITLE && params[:add_parent] != @page.parent.try(:title)
      @page = @page.add_parent(params[:add_parent])
      case @page
        when "ambiguous"
           flash[:alert] = "More than one page with that title"
           @page = Page.find(params[:page_id])
        when "content"
           flash[:alert] = "Parent with that title has content"
           @page = Page.find(params[:page_id])
        when Page
           flash[:notice] = "Page added to this parent"
      end
    end
    redirect_to page_path(@page)
  end
end
