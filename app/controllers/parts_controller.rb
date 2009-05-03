class PartsController < ApplicationController
  def new
    @new_page = Page.new
    @title = "New parent page"
  end
  def edit
    @page = Page.find(params[:id])
    @title = "Edit parts for #{@page.title}"
  end
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    @page.parts_from_urls(params[:url_list])
    redirect_to part_path(@page)
  end
end
