class GenresController < ApplicationController
  def index
    @genres = Genre.all
  end
  def show
    if params[:destroy]
      @genre = Genre.find(params[:id])
      render :destroy and return
    end
    @page = Page.find(params[:id])
    if Genre.count == 0 || params[:add]
      render :new
    else
      render :select
    end
  end
  def edit
    @genre = Genre.find(params[:id])
    @genres = Genre.all
  end
  def update
    @genre = Genre.find(params[:id])
    if params[:commit] == "Merge"
      new_genre = Genre.find_by_name(params[:merge])
      if new_genre == @genre
        flash.now[:alert] = "can't merge with self"
        render :edit and return
      end
      if new_genre.nil?
        flash.now[:alert] = "can't merge with non-existant genre"
        render :edit and return
      end
      new_genre.pages << @genre.pages
      @genre.destroy_me
      redirect_to :root
    elsif @genre.update_attribute(:name, params[:genre][:name])
      redirect_to :root
    else
      render :edit
    end
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Update Genres"
      genre_ids = params[:page][:genre_ids] if params[:page]
      @page.genre_ids = genre_ids
      @page.cache_genres
    elsif params[:commit] == "Add Genres"
      @page.add_genres_from_string = params[:genres]
    end
    redirect_to page_path(@page)
  end
  def destroy
    @genre = Genre.find(params[:id])
    @genre.destroy_me
    redirect_to :root
  end
end
