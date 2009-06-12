class StartController < ApplicationController
 def index
   @new_page = Page.new
   @genre = Genre.find_by_name(params[:genre]) if params[:genre]
   if @genre
     @genre_name = @genre.name
     @page = @genre.pages.first
     @title = "Mobile pages filtered by #{@genre.name}"
   else
     @page = Page.parents.first
     @title = "Mobile pages"
   end
   @genres = Genre.all.map(&:name)
 end
 def create
   if params[:commit] == "Next"
     Page.find(params[:page_id]).next
   end
   if params[:genre]
     redirect_to :action => "index", :genre => params[:genre]
   elsif params[:old_genre]
     redirect_to :action => "index", :genre => params[:old_genre]
   else
     redirect_to :action => "index"
   end
 end
end
