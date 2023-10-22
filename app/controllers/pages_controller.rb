class PagesController < ApplicationController

  def minimal
    @page = Page.new
    @title = "New page"
  end

  def new
    @page = Page.new
    @title = "New page"
  end

  def show
    @page = Page.find(params[:id])
    @title = @page.title
    @count = params[:count].to_i
  end

  def edit # used for editing sections
    @page = Page.find(params[:id])
    @section_number = params[:section].to_i
    @section = @page.section(@section_number)
    @title = "Edit Text #{@section_number} for page: #{@page.title}"
  end

  def reading
    @page = Page.new
    @count = params[:count].to_i
    case params[:commit]
      when "First"
        @count = 0
      when "Next"
        @count = params[:count].to_i + Filter::LIMIT
      when "Previous"
        @count = @count < Filter::LIMIT ? 0 : @count - Filter::LIMIT
      when "Last"
        @count = Page.reading.not_hidden.count - 5
    end
    @title = "Currently Reading"
    @pages = Page.reading.not_hidden.recent.limit(@count + 5)[@count..-1]
    @more = true if @pages.count == Filter::LIMIT
    flash.now[:alert] = "No pages found" if @pages.blank?
  end

  def hidden
    @page = Page.new
    @count = params[:count].to_i
    @title = "Currently Downloaded"
    @pages = Page.reading.hidden.recent.limit(@count + 5)[@count..-1]
    if @pages.count == Filter::LIMIT
      @new_query = {count: @count + Filter::LIMIT}
    end
    flash.now[:alert] = "No pages found" if @pages.blank?
  end

  def soonest
    @page = Page.new
    @count = params[:count].to_i
    @title = "Read Next"
    @pages = Page.soonest.random.limit(@count + 5)[@count..-1]
    if @pages.count == Filter::LIMIT
      @new_query = {count: @count + Filter::LIMIT}
    end
    flash.now[:alert] = "No pages found" if @pages.blank?
  end

  def filter
   if params[:url]
      @page = Page.find_by_url(params[:url].normalize)
      if @page
        flash[:notice] = "One page found"
        redirect_to page_path(@page)
      else
        flash[:alert] = "Page not found"
        redirect_to filter_path and return
      end
    end
    @page = Page.new
    @title = "Filter Pages"
  end

  # Post method used to remove unused paramaters and generate clean query for index
  def find
    page = params.delete(:page)
    if page[:url]
      normalized = page[:url].normalize
      if normalized.blank? && page[:url].present?
        Rails.logger.debug page[:url]
        @page = Page.where("lower(title) LIKE ?", "%" + page[:url].downcase + "%").first
      elsif normalized.present?
        Rails.logger.debug normalized
        @page = Page.find_by_url(normalized)
      end
      if @page
        flash[:notice] = "Page found"
        @count = 0
        redirect_to page_path(@page) and return
      end
    end
    params.delete(:action)
    params.delete(:controller)
    params.delete(:commit)
    params.delete(:authenticity_token)
    params.compact_blank!
    page.compact_blank!
    query = params.to_unsafe_h.merge(page.to_unsafe_h)
    Rails.logger.debug query
    redirect_to pages_path(query)
  end

  def index
    @page = Page.new
    @count = params[:count].to_i
    query = request.query_parameters
    if params[:find]
      name = params[:find]
      @title = "Pages tagged with #{name}"
      @pages = Filter.tag(name, @count)
    else
      @title = "Filtered pages"
      @pages = Filter.new(request.query_parameters)
    end
    if @pages.blank?
      flash.now[:alert] = "No pages found"
    elsif @pages.count == Filter::LIMIT
      @new_query = query.merge(count: @count + Filter::LIMIT)
    end
  end

  ## FIXME ugly
  def create
    if params[:Refetch]
      @page = Page.find_by_url(params[:page][:url].normalize)
      if @page
        flash[:notice] = "Refetched"
        @page = @page.refetch(@page.url)
        @count = @page.parts.size > Page::LIMIT ? @page.parts.size - Page::LIMIT : 0
        render :show and return
      else
        flash[:alert] = "Page not found. Find or Store instead."
        @page = Page.new(params[:page].permit!)
        render :create and return
      end
      return
    end
    if params[:Find]
      normalized = params[:page][:url].normalize
      if normalized.blank? && params[:page][:url].present?
        Rails.logger.debug params[:page][:url]
        @page = Page.where("lower(title) LIKE ?", "%" + params[:page][:url].downcase + "%").first
      elsif normalized.present?
        Rails.logger.debug normalized
        @page = Page.find_by_url(normalized)
      end
      if @page
        flash[:notice] = "Page found"
        @count = 0
        redirect_to page_path(@page) and return
      else
        flash[:alert] = "Page not found."
        @page = Page.new(params[:page].permit!)
        render :create and return
        return
      end
    end
    consolidate_tag_ids
    @page = Page.new(params[:page].permit!)
    if @page.save
      Rails.logger.debug "page saved: #{@page.inspect}"
      if !@page.errors[:base].blank?
        @errors = @page.errors
        Rails.logger.debug "page destroyed because of errors"
        @page.destroy
        @page = Page.new(params[:page])
      else
        @page.reset_hidden
        @page.reset_con
        if @page.tags.fandoms.blank?
          Rails.logger.debug "page created without fandom"
          flash[:notice] = "Page created with #{Page::OTHER}"
          @page.toggle_of
        else
          Rails.logger.debug "page created with fandom"
          flash[:notice] = "Page created."
        end
        flash[:alert] = "edit raw html manually" if @page.ff?
        redirect_to page_path(@page) and return
      end
    else
      @errors = @page.errors
    end
    unless @errors.blank?
      Rails.logger.debug "page errors: #{@errors.messages}"
      flash[:alert] = @errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    end
  end

  ## FIXME huge ugliness ;)
  def update
    @page = Page.find(params[:id])
    @count = params[:count].to_i
    case params[:commit]
      when "Read Now"
        @page.set_reading
      when "First Parts"
        @count = 0
      when "Next Parts"
        @count = params[:count].to_i + Page::LIMIT
      when "Next Unread Part"
        @count = @page.unread_parts.first.position-1
      when "Middle Parts"
        @count = @page.parts.size/2
      when "Previous Parts"
        @count = @count < Page::LIMIT ? 0 : @count - Page::LIMIT
      when "Last Parts"
        @count = @page.parts.size - Page::LIMIT
      when "Change"
        @page.update soon: params[:page][:soon]
        @page.update_read_after
        flash[:notice] = "Read set to #{@page.soon_label}"
      when "Audiobook created"
        @page.make_audio
        flash[:notice] = "Tagged as audio book and marked as read today"
      when "Increase Type"
        @page.increase_type
        flash[:notice] = "Type increased"
      when "Decrease Type"
        @page.decrease_type
        flash[:notice] = "Type decreased"
      when "Increase Position"
        @page.update position: @page.position + 1
        flash[:notice] = "Position increased"
      when "Decrease Position"
        @page.update position: @page.position - 1
        flash[:notice] = "Position decreased"
      when "Update from Parts"
        @page.update_from_parts
        flash[:notice] = "updated"
      when "Rebuild from Raw HTML"
        @page.update scrubbed_notes: false
        @page.rebuild_clean_from_raw.rebuild_edited_from_clean.rebuild_meta
        flash[:notice] = "Rebuilt from Raw HTML"
      when "Remove Downloads"
        @page.remove_outdated_downloads
        flash[:notice] = "Removed Downloads"
      when "Remove Duplicate Tags"
        @page.parts.map(&:remove_duplicate_tags)
        flash[:notice] = "Removed Dupes"
      when "Move Tags to Parent"
        @page.move_tags_up
        flash[:notice] = "Tags Moved"
      when "Rebuild Meta"
        @page.rebuild_meta
        flash[:notice] = "Rebuilt Meta"
      when "Toggle #{Page::OTHER}"
        @page.toggle_of.rebuild_meta
        flash[:notice] = "Toggled #{Page::OTHER}"
      when 'Put end notes after', 'Put end notes before'
        @page.toggle_end.remove_outdated_downloads
        flash[:notice] = "Toggled End Notes"
      when 'Put all end notes after'
        @page.parts.update_all(at_end: true)
        @page.parts.map(&:remove_outdated_downloads)
        @page.remove_outdated_downloads
        flash[:notice] = "Toggled All End Notes"
      when 'Put all end notes before'
        @page.parts.update_all(at_end: false)
        @page.parts.map(&:remove_outdated_downloads)
        @page.remove_outdated_downloads
        flash[:notice] = "Toggled All End Notes"
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
        @page.set_meta
        flash[:notice] = "Raw HTML updated."
      when "Edit HTML"
        @page.edited_html = params[:pasted]
        flash[:notice] = "Clean HTML updated."
      when "Scrub", "Scrub Notes"
        top = params[:top_node] || 0
        bottom = params[:bottom_node] || 0
        Rails.logger.debug "Removing #{top} from top and #{bottom} from bottom"
        case params[:commit]
          when "Scrub"
            Rails.logger.debug "of #{@page.title} content"
            @page.remove_nodes(top, bottom)
            flash[:notice] = "Page scrubbed."
          when "Scrub Notes"
            Rails.logger.debug "of #{@page.title} notes"
            @page.remove_note_nodes(top, bottom)
            flash[:notice] = "Notes scrubbed."
          end
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
      Rails.logger.debug "page errors: #{@page.errors.messages}"
      flash[:alert] = @page.errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    end
    render :show
  end

end
