class PagesController < ApplicationController
  
  def index
    @title = "Mobile pages"
    @page = Page.new(params[:page])
    @size = params[:size]
    @genres = Genre.all.map(&:name)
    @genre = Genre.find_by_name(params[:genre]) if params[:genre]
    @authors = Author.all.map(&:name)
    @author = Author.find_by_name(params[:author]) if params[:author]
    @favorite = params[:favorite] || false
    @unread = params[:unread] || false
    @pages = Page.filter(params)
    flash.now[:error] = "No pages found" if @pages.blank?
  end

  def show
    @page = Page.find(params[:id])
  end

  def create
    if params[:Find]
      build_route = {:action => "index" , :controller => "pages"}
      build_route[:author] = params[:author] unless params[:author].blank?
      build_route[:genre] = params[:genre] unless params[:genre].blank?
      build_route[:size] = params[:size] unless params[:size].blank?
      build_route[:favorite] = "favorite" if params[:favorite]
      build_route[:unread] = "unread" if params[:unread]
      if params[:page]
        build_route[:title] = params[:page][:title] unless params[:page][:title] == "Title"
        build_route[:notes] = params[:page][:notes] unless params[:page][:notes] == "Notes"
        build_route[:url] = params[:page][:url] unless params[:page][:url] == "Url"
      end
      redirect_to(build_route) and return
    end
    @page = Page.new(params[:page])
    genre = Genre.find_by_name(params[:genre])
    author = Author.find_by_name(params[:author])
    @page.favorite = true if params[:favorite] == Page::FAVORITE
    if @page.save
      flash[:error] = @page.errors[:url]
      @page.authors << author if author
      if genre.blank?
        flash[:notice] = "Page created. Please select genre(s)"
        redirect_to genre_path(@page) and return
      else
        flash[:notice] = "Page created."
        @page.genres << genre
        redirect_to read_url(@page) and return
      end
    end
  end

  def update
    @page = Page.find(params[:id])
    @page = @page.make_later if (params[:commit] == "Read Later")
    @page = @page.make_first if (params[:commit] == "Read First")
    case params[:commit]
      when "Raw HTML to UTF8"
        @page.parts.empty? ? @page.build_me("utf8") : @page.parts.each {|p| p.build_me("utf8")}
        flash[:notice] = "HTML converted to utf8"
        redirect_to read_url(@page) and return
      when "Raw HTML to Latin1"
        @page.parts.empty? ? @page.build_me("latin1") : @page.parts.each {|p| p.build_me("latin1")}
        flash[:notice] = "HTML converted to latin1"
        redirect_to read_url(@page) and return
      when "Clean HTML"
        @page.parts.empty? ? @page.clean_me : @page.parts.each {|p| p.clean_me }
        flash[:notice] = "HTML cleaned"
        redirect_to page_url(@page) and return
      when "Update Raw HTML"
        @page.pasted = params[:pasted]
        flash[:notice] = "Raw HTML updated."
        redirect_to read_url(@page) and return
      when "Remove surrounding Div"
        @page.remove_surrounding_div!
        flash[:notice] = "Surrounding div removed"
        redirect_to scrub_path(@page) and return
      when "Scrub"
        @page.remove_nodes(params[:nodes]) if params[:nodes]
        redirect_to read_url(@page) and return
      when "Update"
        @page.update_attributes(params[:page])
        redirect_to page_url(@page) and return
    end
    redirect_to @page
  end
end
