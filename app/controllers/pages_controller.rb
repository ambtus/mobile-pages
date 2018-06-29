class PagesController < ApplicationController

  def index
    @title = "Mobile pages"
    @count = params[:count].to_i
    @page = Page.new(params[:page])
    @page.title = params[:title] if params[:title]
    @page.notes = params[:notes] if params[:notes]
    @page.my_notes = params[:my_notes] if params[:my_notes]
    @page.url = params[:url] if params[:url]
    @sort_by = params[:sort_by] || "read_after"
    @size = params[:size] || "any"
    @unread = params[:unread] || "either"
    @favorite = params[:favorite] || "any"
    @find = params[:find] || "none"
    @genres = Genre.all.map(&:name)
    @genre = Genre.find_by_name(params[:genre]) if params[:genre]
    @genre2 = Genre.find_by_name(params[:genre2]) if params[:genre2]
    @hiddens = Hidden.all.map(&:name)
    @hidden = Hidden.find_by_name(params[:hidden]) if params[:hidden]
    @authors = Author.all.map(&:name)
    @author = Author.find_by_name(params[:author]) if params[:author]
    @pages = Page.filter(params)
    flash.now[:alert] = "No pages found" if @pages.to_a.empty?
  end

  def show
    @page = Page.find(params[:id])
  end

  def create
    if params[:Find] || params[:Next]
      build_route = {:action => "index" , :controller => "pages"}
      build_route[:count] = params[:count].to_i + Page::LIMIT if params[:Next]
      build_route[:author] = params[:author] unless params[:author].blank?
      build_route[:genre] = params[:genre] unless params[:genre].blank?
      build_route[:genre2] = params[:genre2] unless params[:genre2].blank?
      build_route[:hidden] = params[:hidden] unless params[:hidden].blank?
      build_route[:sort_by] = params[:sort_by] unless (params[:sort_by].blank? || params[:sort_by] == "read_after")
      build_route[:size] = params[:size] unless (params[:size].blank? || params[:size] == "any")
      build_route[:favorite] = params[:favorite] unless (params[:favorite].blank? || params[:favorite] == "any")
      build_route[:find] = params[:find] unless (params[:find].blank? || params[:find] == "none")
      build_route[:unread] = params[:unread] unless (params[:unread].blank? || params[:unread] == "either")
      if params[:page]
        build_route[:title] = params[:page][:title] unless params[:page][:title] == "Title"
        build_route[:notes] = params[:page][:notes] unless params[:page][:notes] == "Notes"
        build_route[:my_notes] = params[:page][:my_notes] unless params[:page][:my_notes] == "My Notes"
        build_route[:url] = params[:page][:url] unless params[:page][:url] == "URL"
      end
      redirect_to(build_route) and return
    end
    @page = Page.new(params[:page].permit!)
    @genre = Genre.find_by_name(params[:genre])
    @genre2 = Genre.find_by_name(params[:genre2])
    @hidden = Hidden.find_by_name(params[:hidden])
    @author = Author.find_by_name(params[:author])
    @favorite = params[:favorite]
    @find = params[:find]
    if @page.save
      if !@page.errors[:base].blank?
        @errors = @page.errors
        @page.destroy
        @page = Page.new(params[:page])
        @page.favorite = true if params[:favorite] == "favorite"
      else
        @page.update_attribute(:favorite, @favorite)
        @page.authors << @author if @author
        if @genre.blank?
          flash[:notice] = "Page created. Please select genre(s)"
          redirect_to genre_path(@page) and return
        else
          flash[:notice] = "Page created."
          @page.genres << @genre if @genre
          @page.genres << @genre2 if @genre2
          @page.cache_genres
          @page.hiddens << @hidden if @hidden
          @page.cache_hiddens
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
    @page.make_audio if (params[:commit] == "Audiobook created")
    case params[:commit]
      when "Read First"
        @page.make_first
        flash[:notice] = "Set to Read First"
        redirect_to root_path and return
      when "Rebuild from Raw HTML"
        @page.rebuild_clean_from_raw
        flash[:notice] = "Rebuilt from Raw HTML"
        redirect_to page_path(@page) and return
      when "Rebuild from Clean HTML"
        @page.rebuild_edited_from_clean
        flash[:notice] = "Rebuilt from Clean HTML"
        redirect_to page_path(@page) and return
      when "Update Raw HTML"
        @page.raw_html = params[:pasted]
        flash[:notice] = "Raw HTML updated."
        redirect_to page_path(@page) and return
      when "Update Scrubbed HTML"
        @page.clean_html = params[:pasted]
        flash[:notice] = "Clean HTML updated."
        redirect_to page_path(@page) and return
      when "Scrub"
        top = params[:top_node] || 0
        bottom = params[:bottom_node] || 0
        @page.remove_nodes(top, bottom)
        redirect_to page_path(@page) and return
      when "Update"
        @page.update_attributes(params[:page].permit!)
        @page.remove_outdated_downloads
        redirect_to page_url(@page) and return
      when "Preview Text"
        @section_number = params[:section].to_i
        @old = @page.section(@section_number)
        @new = params[:edited]
        render :preview and return
      when "Confirm Text Edit"
        @page.edit_section(params[:section].to_i,params[:new])
        redirect_to @page.download_url(".read") and return
    end
    redirect_to @page
  end

  def edit # used for editing sections
    @page = Page.find(params[:id])
    @section_number = params[:section].to_i
    @section = @page.section(@section_number)
  end
end
