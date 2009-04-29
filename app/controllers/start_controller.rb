class StartController < ApplicationController
 def index
   @page = Page.first
 end
 def create
   @page = Page.find(params[:page_id])
   if params[:commit] == "Next"
     @page.next
     redirect_to root_url
   end
 end
end
