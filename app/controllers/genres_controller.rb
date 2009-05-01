class GenresController < ApplicationController
  def show
    @page = Page.find(params[:id])
    if Genre.count == 0 || params[:add]
      render :new
    else
      render :select
    end
  end
  def create
    @page = Page.find(params[:page_id])
    @page.update_attributes(params[:page])
    @page.add_genre_string = params[:genres]
    redirect_to page_path(@page)
  end
end
