class StartController < ApplicationController
 def index
   @genre = Genre.find_by_name(params[:genre]) if params[:genre]
   if @genre
     @page = @genre.pages.first
     @title = "Mobile pages filtered by #{@genre.name}"
   else
     @page = Page.first
     @title = "Mobile pages"
   end
   @new_page = Page.new
   @genres = Genre.all.map(&:name)
 end
 def create
   if params[:commit] == "Next"
     Page.find(params[:page_id]).next
   end
   if params[:genre]
     redirect_to :action => "index", :genre => params[:genre]
   else
     redirect_to :action => "index"
   end
 end
end
