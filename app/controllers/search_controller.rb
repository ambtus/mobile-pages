class SearchController < ApplicationController
  def create
    @page = Page.search(params[:search])
    if @page
      @page = @page.parent if @page.parent
      redirect_to @page
    else
      flash[:error] = "Not found"
      redirect_to root_url
    end
  end
end
