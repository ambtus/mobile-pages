class PagesController < ApplicationController

  def new
    @page = Page.new
    @title = "New page"
  end

  def index
    requested = request.query_parameters
    if requested[:url]
      @page = Page.find_by_url(requested[:url].normalize)
      if @page
        flash[:notice] = "One page found"
        @count = 0
        render :show
      end
    end
    @page = Page.new(requested[:page])
    @count = requested[:count].to_i
    if requested.keys.include?("find")
      Rails.logger.debug "DEBUG: find #{requested}"
      @title = "Pages tagged with #{requested[:find]}"
      @find = requested[:find]
      @pages = Filter.tag(requested[:find], @count)
      flash.now[:alert] = "No pages found" if @pages.to_a.empty?
    elsif requested.empty? || requested.keys == ["count"]
      Rails.logger.debug "DEBUG: index page"
      @title = "Mobile pages"
      @index = true
      @called_by = "index"
      @pages = Filter.new(requested)
      flash.now[:alert] = "No pages found" if @pages.to_a.empty?
    else
      @title = "Filter pages"
      @filter = true
      @called_by = "filter"
      if requested.keys == ["q"]
        Rails.logger.debug "DEBUG: empty filter page"
        @pages = []
      else
        Rails.logger.debug "DEBUG: filter on #{requested}"
        @pages = Filter.new(requested)
        flash.now[:alert] = "No pages found" if @pages.to_a.empty?
        @page.title = params[:title] if params[:title]
        @page.notes = params[:notes] if params[:notes]
        @page.my_notes = params[:my_notes] if params[:my_notes]
        @page.url = params[:url] if params[:url]
        Tag.types.each do |tag_type|
          instance_variable_set("@#{tag_type.downcase}_name", params[tag_type.downcase]) if params[tag_type.downcase]
        end
      end
      @type = params[:type] || "any"
      @sort_by = params[:sort_by] || "default"
      @size = params[:size] || "any"
      @unread = params[:unread] || "either"
      @stars = params[:stars] || "any"
    end
  end

  def create
    if params[:Find] || params[:Next]
      build_route = {:action => "index" , :controller => "pages"}
      build_route[:find] = params[:find] unless params[:find].blank?
      build_route[:count] = params[:count].to_i + Filter::LIMIT if params[:Next]
      build_route[:author] = params[:author] unless params[:author].blank?
      build_route[:hidden] = params[:hidden] unless params[:hidden].blank?
      build_route[:fandom] = params[:fandom] unless params[:fandom].blank?
      build_route[:pro] = params[:pro] unless params[:pro].blank?
      build_route[:con] = params[:con] unless params[:con].blank?
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
    if params[:Refetch]
      @page = Page.find_by_url(params[:page][:url].normalize)
      if @page
        flash[:notice] = "Refetched"
        @page.refetch(@page.url)
        @page = Page.find(@page.id) # rather than reload, in case its class changed
        @count = @page.parts.size > Page::LIMIT ? @page.parts.size - Page::LIMIT : 0
        render :show and return
      else
        flash[:alert] = "Page not found. Find or Store instead."
        @page = Page.new(params[:page].permit!)
        render :create and return
      end
      return
    end
    @page = Page.new(params[:page].permit!)
    @hidden = Hidden.find_by_short_name(params[:hidden])
    @fandom = Fandom.find_by_short_name(params[:fandom])
    @author = Author.find_by_short_name(params[:author])
    @pro = Pro.find_by_short_name(params[:pro])
    @con = Con.find_by_short_name(params[:con])
    @info = Info.find_by_short_name(params[:info])
    @page.tags << [@hidden, @author, @fandom, @pro, @con, @info].compact
    if @page.save
      Rails.logger.debug "DEBUG: page saved: #{@page.inspect}"
      if !@page.errors[:base].blank?
        @errors = @page.errors
        Rails.logger.debug "DEBUG: page destroyed because of errors"
        @page.destroy
        @page = Page.new(params[:page])
      else
        @page.set_hidden unless @hidden.blank?
        if @page.tags.fandoms.blank?
          Rails.logger.debug "DEBUG: page created without fandom"
          flash[:notice] = "Page created with #{Page::OTHER}"
          @page.toggle_of
        else
          Rails.logger.debug "DEBUG: page created with fandom"
          flash[:notice] = "Page created."
        end
        redirect_to page_path(@page) and return
      end
    else
      @errors = @page.errors
    end
    unless @errors.blank?
      Rails.logger.debug "DEBUG: page errors: #{@errors.messages}"
      flash[:alert] = @errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    end
  end

  def show
    @page = Page.find(params[:id])
    @count = params[:count].to_i
  end

  def update
    @page = Page.find(params[:id])
    @count = params[:count].to_i
    case params[:commit]
      when "Next Parts"
        @count = params[:count].to_i + Page::LIMIT
      when "Last Parts"
        @count = @page.parts.size - Page::LIMIT
      when "Previous Parts"
        @count = @count < Page::LIMIT ? 0 : @count - Page::LIMIT
      when "First Parts"
        @count = 0
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
        @page.rebuild_clean_from_raw.rebuild_edited_from_clean.rebuild_meta
        flash[:notice] = "Rebuilt from Raw HTML"
      when "Remove Downloads"
        @page.remove_outdated_downloads
        flash[:notice] = "Removed Downloads"
      when "Remove Duplicate Tags"
        @page.parts.map(&:remove_duplicate_tags)
        flash[:notice] = "Removed Dupes"
      when "Rebuild Meta"
        @page.rebuild_meta
        flash[:notice] = "Rebuilt Meta"
      when "Toggle #{Page::OTHER}"
        @page.toggle_of.rebuild_meta
        flash[:notice] = "Toggled #{Page::OTHER}"
      when "Toggle #{Page::TT}"
        @page.toggle_tt.remove_outdated_downloads
        flash[:notice] = "Toggled #{Page::TT}"
      when "Toggle End Notes"
        @page.toggle_end.remove_outdated_downloads
        flash[:notice] = "Toggled End Notes"
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
    unless @page.errors.blank?
      Rails.logger.debug "DEBUG: page errors: #{@page.errors.messages}"
      flash[:alert] = @page.errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    end
    @page = Page.find(@page.id) # in case something changed
    render :show
  end

  def edit # used for editing sections
    @page = Page.find(params[:id])
    @section_number = params[:section].to_i
    @section = @page.section(@section_number)
  end
end
