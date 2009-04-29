class SearchController < ApplicationController
  def create
    @page = Page.search(params[:search])
    if @page
      redirect_to @page
    else
      flash[:error] = "Not found"
      redirect_to root_url
    end
  end
end
