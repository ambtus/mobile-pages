class SearchController < ApplicationController
  def create
    @page = Page.search(params[:search])
    if @page
      @page = @page.parent if @page.parent
      if @page.parts.blank?
        redirect_to @page
      else
        redirect_to part_path(@page)
      end
    else
      flash[:error] = "Not found"
      redirect_to root_url
    end
  end
end
