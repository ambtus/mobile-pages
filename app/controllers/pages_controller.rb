class PagesController < ApplicationController

  def index
    if params[:url]
      @page = Page.find_by_url(params[:url])
      render :show and return if @page
    end
    @title = "Mobile pages"
    @count = params[:count].to_i
    @page = Page.new(params[:page])
    @page.title = params[:title] if params[:title]
    @page.notes = params[:notes] if params[:notes]
    @page.my_notes = params[:my_notes] if params[:my_notes]
    @page.url = params[:url] if params[:url]
    @type = params[:type] || "any"
    @sort_by = params[:sort_by] || "default"
    @size = params[:size] || "any"
    @unread = params[:unread] || "either"
    @stars = params[:stars] || "any"
    @tag = Tag.find_by_name(params[:tag]) if params[:tag]
    @fandom = Fandom.find_by_name(params[:fandom]) if params[:fandom]
    @character = Character.find_by_name(params[:character]) if params[:character]
    @rating = Rating.find_by_name(params[:rating]) if params[:rating]
    @omitted = Omitted.find_by_name(params[:omitted]) if params[:omitted]
    @hidden = Hidden.find_by_name(params[:hidden]) if params[:hidden]
    @info = Info.find_by_name(params[:info]) if params[:info]
    @author_name = params[:author] if params[:author]
    @pages = Filter.new(params)
    flash.now[:alert] = "No pages found" if @pages.to_a.empty?
  end

  def show
    @page = Page.find(params[:id])
  end

  def create
    if params[:Find] || params[:Next]
      build_route = {:action => "index" , :controller => "pages"}
      build_route[:count] = params[:count].to_i + Filter::LIMIT if params[:Next]
      build_route[:author] = params[:author] unless params[:author].blank?
      build_route[:tag] = params[:tag] unless params[:tag].blank?
      build_route[:hidden] = params[:hidden] unless params[:hidden].blank?
      build_route[:fandom] = params[:fandom] unless params[:fandom].blank?
      build_route[:character] = params[:character] unless params[:character].blank?
      build_route[:rating] = params[:rating] unless params[:rating].blank?
      build_route[:omitted] = params[:omitted] unless params[:omitted].blank?
      build_route[:info] = params[:info] unless params[:info].blank?
      build_route[:type] = params[:type] unless (params[:type].blank? || params[:type] == "any")
      build_route[:sort_by] = params[:sort_by] unless (params[:sort_by].blank? || params[:sort_by] == "default")
      build_route[:size] = params[:size] unless (params[:size].blank? || params[:size] == "any")
      build_route[:stars] = params[:stars] unless (params[:stars].blank? || params[:stars] == "any")
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
    @tag = Tag.find_by_name(params[:tag])
    @hidden = Hidden.find_by_name(params[:hidden])
    @fandom = Fandom.find_by_name(params[:fandom])
    @character = Character.find_by_name(params[:character])
    @rating = Rating.find_by_name(params[:rating])
    @omitted = Omitted.find_by_name(params[:omitted])
    @info = Info.find_by_name(params[:info])
    @page.tags << [@tag, @hidden, @fandom, @omitted, @character, @rating, @info].compact
    @author_name = params[:author] unless params[:author].blank?
    @author = Author.find_by_short_name(params[:author])
    @page.authors << @author if @author
    if @page.save
      if !@page.errors[:base].blank?
        @errors = @page.errors
        @page.destroy
        @page = Page.new(params[:page])
      else
        @page.convert_to_type
        @page.cache_tags
        if @page.tags.fandom.blank?
          flash[:notice] = "Page created. Please select fandom(s)"
          redirect_to tag_path(@page) and return
        else
          flash[:notice] = "Page created."
          redirect_to page_path(@page) and return
        end
      end
    else
      @errors = @page.errors
    end
    flash[:alert] = @errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
  end

  def update
    @page = Page.find(params[:id])
    case params[:commit]
      when "Read Now"
        @page.make_first
        flash[:notice] = "Set to Read Now"
        redirect_to root_path and return
      when "Read Later"
        @page.update_read_after
        @page.parent.update_read_after if @page.parent
        @page.parent.parent.update_read_after if @page.parent && @page.parent.parent
        flash[:notice] = "Reset read after date"
        redirect_to root_path and return
      when "Audiobook created"
        @page.make_audio
        flash[:notice] = "Tagged as audio book and marked as read today"
      when "Rebuild from Raw HTML"
        @page.rebuild_clean_from_raw
        flash[:notice] = "Rebuilt from Raw HTML"
      when "Rebuild from Scrubbed HTML"
        @page.rebuild_edited_from_clean
        flash[:notice] = "Rebuilt from Scrubbed HTML"
      when "Remove Downloads"
        @page.remove_outdated_downloads
        flash[:notice] = "Removed Downloads"
      when "Remove Duplicate Tags"
        @page.parts.map(&:remove_duplicate_tags)
        flash[:notice] = "Removed Dupes"
      when "Rebuild Meta"
        @page.rebuild_meta
        flash[:notice] = "Rebuilt Meta"
      when "Make Single"
        @page.make_single
        flash[:notice] = "Made Single"
      when "Uncollect"
        @page.parts.map(&:make_single)
        @page.destroy
        flash[:notice] = "Uncollected"
        redirect_to root_path and return
      when "Update Raw HTML"
        @page.raw_html = params[:pasted]
        flash[:notice] = "Raw HTML updated."
      when "Edit HTML"
        @page.edited_html = params[:pasted]
        flash[:notice] = "Clean HTML updated."
      when "Scrub"
        top = params[:top_node] || 0
        bottom = params[:bottom_node] || 0
        @page.remove_nodes(top, bottom)
      when "Update"
        @page.update(params[:page].permit!)
        @page.remove_outdated_downloads
      when "Preview Text"
        @section_number = params[:section].to_i
        @old = @page.section(@section_number)
        @new = params[:edited]
        render :preview and return
      when "Confirm Text Edit"
        @page.edit_section(params[:section].to_i,params[:new])
        redirect_to @page.download_url(".read") and return
    end
    render :show
  end

  def edit # used for editing sections
    @page = Page.find(params[:id])
    @section_number = params[:section].to_i
    @section = @page.section(@section_number)
  end
end
