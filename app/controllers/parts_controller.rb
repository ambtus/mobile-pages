class PartsController < ApplicationController
  NEW_PARENT_TITLE = "Enter the title of the desired Parent Page"

  def new
    @new_page = Page.new
    @title = "New parent page"
  end

  def edit
    @page = Page.find(params[:id])
    case params[:add]
    when "title"
      @title = "Edit title for #{@page.title}"
      render "title"
    when "part"
      @title = "Add part to #{@page.title}"
      render "part"
    when "parent"
      @title = "Add parent to #{@page.title}"
      @parent_title = NEW_PARENT_TITLE
      render "parent"
    else
      raise "missing or bad params[:add] (#{params[:add]})"
    end
  end

  def create
    @page = Page.find(params[:page_id])
    @count = 0
    if params[:title]
      @page.update_attribute(:title, params[:title])
    elsif params[:add_url]
      @page.add_part(params[:add_url])
      flash[:notice] = "Part added"
      @count = @page.parts.size > Page::LIMIT ? @page.parts.size - Page::LIMIT : 0
    elsif params[:add_parent]
      @parent = @page.add_parent(params[:add_parent])
      case @parent
      when "ambiguous"
         flash[:alert] = "More than one page with that title"
      when "content"
         flash[:alert] = "Parent with that title has content"
      when Page
         flash[:notice] = "Page added to this parent"
         @count = @page.position > Page::LIMIT ? @page.position - Page::LIMIT : 0
         @page = @parent
      end
    else
      raise "missing or bad params (#{request.query_parameters})"
    end
    render 'pages/show' and return
  end
end
