class StartController < ApplicationController
  def index
    @genres = Genre.all.map(&:name)
    @authors = Author.all.map(&:name)
    @new_page = Page.new
    @genre = Genre.find_by_name(params[:genre]) if params[:genre]
    @author = Author.find_by_name(params[:author]) if params[:author]
    @unread = params[:unread]
    @favorite = params[:favorite]
    @size = params[:size]
    @search = params[:search] ? params[:search] : Page::SEARCH_PLACEHOLDER
    @page = Page.filter(@size, @unread, @favorite, @genre, @author).first
    if @genre || @author || @unread || @favorite || @size
      filter_string = [@size, @unread, @favorite, @author.try(:name), @genre.try(:name)].compact.join(", ")
      @title = "Mobile pages filtered by #{filter_string}"
      flash.now[:error] = "No page with filters #{filter_string}" unless @page
    else
      @title = "Mobile pages"
    end
  end
end
