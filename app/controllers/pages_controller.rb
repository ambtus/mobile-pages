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
    @tags = Tag.all.map(&:name)
    @tag = Tag.find_by_name(params[:tag]) if params[:tag]
    @fandom = Fandom.find_by_name(params[:fandom]) if params[:fandom]
    @relationship = Relationship.find_by_name(params[:relationship]) if params[:relationship]
    @rating = Rating.find_by_name(params[:rating]) if params[:rating]
    @omitted = Omitted.find_by_name(params[:omitted]) if params[:omitted]
    @hidden = Hidden.find_by_name(params[:hidden]) if params[:hidden]
    @info = Info.find_by_name(params[:info]) if params[:info]
    @author_name = params[:author] if params[:author]
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
      build_route[:tag] = params[:tag] unless params[:tag].blank?
      build_route[:hidden] = params[:hidden] unless params[:hidden].blank?
      build_route[:fandom] = params[:fandom] unless params[:fandom].blank?
      build_route[:relationship] = params[:relationship] unless params[:relationship].blank?
      build_route[:rating] = params[:rating] unless params[:rating].blank?
      build_route[:omitted] = params[:omitted] unless params[:omitted].blank?
      build_route[:info] = params[:info] unless params[:info].blank?
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
    @tag = Tag.find_by_name(params[:tag])
    @hidden = Hidden.find_by_name(params[:hidden])
    @fandom = Fandom.find_by_name(params[:fandom])
    @relationship = Relationship.find_by_name(params[:relationship])
    @rating = Rating.find_by_name(params[:rating])
    @omitted = Omitted.find_by_name(params[:omitted])
    @info = Info.find_by_name(params[:info])
    @author_name = params[:author] unless params[:author].blank?
    @author = Author.find_by_short_name(params[:author])
    @find = params[:find]
    if @page.save
      if !@page.errors[:base].blank?
        @errors = @page.errors
        @page.destroy
        @page = Page.new(params[:page])
      else
        @page.authors << @author if @author
        @page.tags << @tag if @tag
        @page.tags << @hidden if @hidden
        @page.tags << @fandom if @fandom
        @page.tags << @omitted if @omitted
        @page.tags << @relationship if @relationship
        @page.tags << @rating if @rating
        @page.tags << @info if @info
        @page.cache_tags
        if @fandom.blank?
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
    flash[:alert] = @errors.collect {|e, m| "#{e.to_s.humanize unless e == "Base"} #{m}"}.join(" and  ")
  end

  def update
    @page = Page.find(params[:id])
    case params[:commit]
      when "Read Now"
        @page.make_first
        flash[:notice] = "Set to Read Now"
        redirect_to root_path and return
      when "Read Later"
        @page.make_last
        flash[:notice] = "Set to Read Later"
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
      when "Rebuild Meta"
        @page.rebuild_meta
        flash[:notice] = "Rebuilt Meta"
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
