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
    if params[:commit] == "Update Genres"
      genre_ids = params[:page][:genre_ids] if params[:page]
      @page.genre_ids = genre_ids
    elsif params[:commit] == "Add Genres"
      @page.add_genre_string = params[:genres]
    end
    redirect_to page_path(@page)
  end
end
