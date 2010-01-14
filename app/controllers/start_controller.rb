class StartController < ApplicationController
 def index
   @new_page = Page.new
   @genres = Genre.all.map(&:name)
   @genre = Genre.find_by_name(params[:genre]) if params[:genre]
   @authors = Author.all.map(&:name)
   @author = Author.find_by_name(params[:author]) if params[:author]
   @states = State.all.map(&:name)
   @state = State.find_by_name(params[:state]) if params[:state]
   @page = Page.filter(@state, @genre, @author).first
   if @genre || @author || @state
     filter_string = [@state.try(:name), @author.try(:name), @genre.try(:name)].compact.join(", ")
     @title = "Mobile pages filtered by #{filter_string}"
     flash.now[:error] = "No page with filters #{filter_string}" unless @page
   else
     @title = "Mobile pages"
   end
 end
 def create
   if params[:commit] == "Read Later"
     Page.find(params[:page_id]).next
   end
   if params[:Filter]
     redirect_to :action => "index", :genre => params[:genre], :author => params[:author], :state => params[:state]
   else
     redirect_to :action => "index", :genre => params[:old_genre], :author => params[:old_author], :state => params[:old_state]
   end
 end
end
