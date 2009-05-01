class StartController < ApplicationController
 def index
   @new_page = Page.new
   if params[:multiple]
     @title = "Mobile pages (new multiple)"
     render :multiple and return
   end
   @genre = Genre.find_by_name(params[:genre]) if params[:genre]
   if @genre
     @page = @genre.pages.parents.first
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
   else
     redirect_to :action => "index"
   end
 end
end
