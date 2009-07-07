class StartController < ApplicationController
 def index
   @new_page = Page.new
   @genre = Genre.find_by_name(params[:genre]) if params[:genre]
   @author = Author.find_by_name(params[:author]) if params[:author]
   if @genre && !@author
     @genre_name = @genre.name
     @page = @genre.pages.first
     @title = "Mobile pages filtered by #{@genre.name}"
   elsif @author && !@genre
     @author_name = @author.name
     @page = @author.pages.first
     @title = "Mobile pages filtered by #{@author.name}"
   elsif @author && @genre
     @genre_name = @genre.name
     @author_name = @author.name
     @page = Page.by_author_and_genre(@author, @genre).first
     @title = "Mobile pages filtered by #{@author.name} and #{@genre.name}"
     flash[:error] = "No page with both filters" unless @page
   else
     @page = Page.parents.first
     @title = "Mobile pages"
   end
   @genres = Genre.all.map(&:name)
   @authors = Author.all.map(&:name)
 end
 def create
   if params[:commit] == "Read Later"
     Page.find(params[:page_id]).next
   end
   if !params[:genre].blank? && params[:author].blank?
     redirect_to :action => "index", :genre => params[:genre]
   elsif params[:genre].blank? && !params[:author].blank?
     redirect_to :action => "index", :author => params[:author]
   elsif !params[:genre].blank? && !params[:author].blank?
     redirect_to :action => "index", :author => params[:author], :genre => params[:genre]
   elsif params[:old_genre]
     redirect_to :action => "index", :genre => params[:old_genre]
   else
     redirect_to :action => "index"
   end
 end
end
