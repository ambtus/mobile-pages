class PagesController < ApplicationController

  def index
    @title = "Mobile pages"
    @page = Page.new(params[:page])
    @page.title = params[:title] if params[:title]
    @page.notes = params[:notes] if params[:notes]
    @page.url = params[:url] if params[:url]
    @sort_by = params[:sort_by] || "read_after"
    @size = params[:size] || "any"
    @unread = params[:unread] || "either"
    @favorite = params[:favorite] || "any"
    @genres = Genre.all.map(&:name)
    @genre = Genre.find_by_name(params[:genre]) if params[:genre]
    @authors = Author.all.map(&:name)
    @author = Author.find_by_name(params[:author]) if params[:author]
    @pages = Page.filter(params)
    flash.now[:alert] = "No pages found" if @pages.to_a.empty?
  end

  def show
    @page = Page.find(params[:id])
  end

  def create
    if params[:Find]
      build_route = {:action => "index" , :controller => "pages"}
      build_route[:author] = params[:author] unless params[:author].blank?
      build_route[:genre] = params[:genre] unless params[:genre].blank?
      build_route[:sort_by] = params[:sort_by] unless (params[:sort_by].blank? || params[:sort_by] == "read_after")
      build_route[:size] = params[:size] unless (params[:size].blank? || params[:size] == "any")
      build_route[:favorite] = params[:favorite] unless (params[:favorite].blank? || params[:favorite] == "any")
      build_route[:unread] = params[:unread] unless (params[:unread].blank? || params[:unread] == "either")
      if params[:page]
        build_route[:title] = params[:page][:title] unless params[:page][:title] == "Title"
        build_route[:notes] = params[:page][:notes] unless params[:page][:notes] == "Notes"
        build_route[:url] = params[:page][:url] unless params[:page][:url] == "URL"
      end
      redirect_to(build_route) and return
    end
    @page = Page.new(params[:page])
    @genre = Genre.find_by_name(params[:genre])
    @author = Author.find_by_name(params[:author])
    @favorite = params[:favorite]
    if @page.save
      if !@page.errors[:base].blank?
        @errors = @page.errors
        @page.destroy
        @page = Page.new(params[:page])
        @page.favorite = true if params[:favorite] == Page::FAVORITE
      else
        @page.favorite = @favorite
        @page.authors << @author if @author
        if @genre.blank?
          flash[:notice] = "Page created. Please select genre(s)"
          redirect_to genre_path(@page) and return
        else
          flash[:notice] = "Page created."
          @page.genres << @genre
          redirect_to page_path(@page) and return
        end
      end
    else
      @errors = @page.errors
    end
    flash[:alert] = @errors.collect {|e, m| "#{e.to_s.humanize unless e == "Base"} #{m}"}.join(" and  ")
  end

  def update
    @page = Page.find(params[:id])
    @page = @page.make_first if (params[:commit] == "Read First")
    @page = @page.make_reading if (params[:commit] == "Reading")
    @page.remove_outdated_downloads if (params[:commit] == "Remove Downloads")
    case params[:commit]
      when "Rebuild from Raw HTML"
        @page.rebuild_from_raw
        flash[:notice] = "Rebuilt from Raw HTML"
        redirect_to page_path(@page) and return
      when "Update Raw HTML"
        @page.raw_html = params[:pasted]
        flash[:notice] = "Raw HTML updated."
        redirect_to page_path(@page) and return
      when "Remove surrounding Div"
        @page.remove_surrounding_div!
        flash[:notice] = "Surrounding div removed"
        redirect_to scrub_path(@page) and return
      when "Scrub"
        top = params[:top_node] || 0
        bottom = params[:bottom_node] || 0
        @page.remove_nodes(top, bottom)
        redirect_to page_path(@page) and return
      when "Update"
        @page.update_attributes(params[:page])
        redirect_to page_url(@page) and return
    end
    redirect_to @page
  end
end
