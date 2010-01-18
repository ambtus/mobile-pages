class SearchController < ApplicationController
  def create
    @search_string = params[:search] unless params[:search] == Page::SEARCH_PLACEHOLDER
    if @search_string.blank?
      flash[:error] = "Please enter search criteria"
      redirect_to pages_url and return
    end
    @pages = Page.search(@search_string)
    if @pages.empty?
      flash[:error] = @search_string + " not found"
      redirect_to pages_url
    else 
      if @pages.size == 1
        @page = @pages.first
        @page = @page.parent if @page.parent
        if @page.parts.blank?
          redirect_to @page
        else
          redirect_to part_path(@page)
        end
      else
        render :index
      end
    end
  end
end
