class PagesController < ApplicationController
  def create
    if params[:Filter] || params[:Later]
      build_route = {:action => "index" , :controller => "start"}
      build_route[:author] = params[:author] unless params[:author].blank?
      build_route[:genre] = params[:genre] unless params[:genre].blank?
      build_route[:size] = params[:size] unless params[:size].blank?
      build_route[:favorite] = params[:favorite] unless params[:favorite].blank?
      build_route[:unread] = params[:unread] unless params[:unread].blank?
      Page.find_by_id(params[:page_id]).next if params[:Later]
      redirect_to(build_route) and return
    end
    @page = Page.new(params[:page])
    @genre = Genre.find_by_name(params[:genre])
    author = Author.find_by_name(params[:author])
    @page.favorite = true if params[:favorite] == Page::FAVORITE
    if @page.save
      flash[:error] = @page.errors[:url]
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
