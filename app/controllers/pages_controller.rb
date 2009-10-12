class PagesController < ApplicationController
  def create
    if params[:Filter]
      redirect_to (:action => "index" , :controller => "start", :author => params[:author], :genre => params[:genre], :state => params[:state]) and return
    end
    @page = Page.new(params[:page])
    @genre = Genre.find_by_name(params[:genre])
    if @page.save
      if @genre.blank?
        flash[:notice] = "Page created. Please select genre(s)"
        redirect_to genre_path(@page) and return
      else
        flash[:notice] = "Page created."
        @page.genres << @genre
        redirect_to @page and return
      end
    end
  end
  def show
    @page = Page.find(params[:id])
  end
  def update
    @page = Page.find(params[:id])
    @page = @page.next if (params[:commit] == "Read Later")
    @page = @page.first if (params[:commit] == "Read First")
    if params[:commit] == "Make UTF8"
      if @page.parts.empty?
        @page.build_me("utf8")
      else
        @page.parts.each {|p| p.build_me("utf8")}
      end
    end
    if params[:commit] == "Update Raw HTML"
      @page.pasted = params[:pasted]
      flash[:notice] = "Raw HTML updated."
    end
    @page.remove_nodes(params[:nodes]) if params[:nodes]
    @page.update_attributes(params[:page])
    redirect_to @page
  end
end
