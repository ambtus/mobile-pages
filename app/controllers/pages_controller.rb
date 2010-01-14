class PagesController < ApplicationController
  def create
    if params[:Filter]
      redirect_to(:action => "index" , :controller => "start", :author => params[:author], :genre => params[:genre], :state => params[:state]) and return
    end
    @page = Page.new(params[:page])
    @genre = Genre.find_by_name(params[:genre])
    author = Author.find_by_name(params[:author])
    if @page.save
      @page.authors << author if author
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
    case params[:commit]
      when "Raw HTML to UTF8"
        @page.parts.empty? ? @page.build_me("utf8") : @page.parts.each {|p| p.build_me("utf8")}
        flash[:notice] = "HTML converted to utf8"
      when "Raw HTML to Latin1"
        @page.parts.empty? ? @page.build_me("latin1") : @page.parts.each {|p| p.build_me("latin1")}
        flash[:notice] = "HTML converted to latin1"
      when "Clean HTML"
        @page.parts.empty? ? @page.clean_me : @page.parts.each {|p| p.clean_me }
        flash[:notice] = "HTML cleaned"
      when "Update Raw HTML"
        @page.pasted = params[:pasted]
        flash[:notice] = "Raw HTML updated."
      when "Remove surrounding Div"
        @page.remove_surrounding_div!
        flash[:notice] = "Surrounding div removed"
        redirect_to scrub_path(@page) and return
    end
    @page.remove_nodes(params[:nodes]) if params[:nodes]
    @page.update_attributes(params[:page])
    redirect_to @page
  end
end
