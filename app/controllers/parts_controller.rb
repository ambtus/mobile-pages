# frozen_string_literal: true

class PartsController < ApplicationController
  PARENT_PLACEHOLDER = 'Title of existing or new parent page'
  URL_PLACEHOLDER = 'URL of part to add'

  def new
    @page = Page.new
    @title = 'New parent page'
  end

  def edit
    @page = Page.find(params[:id])
    case params[:add]
    when 'title'
      @title = "Edit title for #{@page.title}"
      render 'title'
    when 'part'
      @title = "Add part to #{@page.title}"
      @hint = URL_PLACEHOLDER
      render 'part'
    when 'parent'
      @title = "Add parent to #{@page.title}"
      @hint = PARENT_PLACEHOLDER
      render 'parent'
    else
      raise "missing or bad params[:add] (#{params[:add]})"
    end
  end

  def create
    @page = Page.find(params[:page_id])
    @count = 0
    if params[:title]
      @page.update_attribute(:title, params[:title])
    elsif params[:add_url]
      url = params[:add_url] unless params[:add_url] == URL_PLACEHOLDER
      @page.add_part(url) if url.present?
      flash[:notice] = 'Part added' if url.present?
      part = Page.find_by(url: url)
      if part && part.raw_html.blank?
        flash[:alert] = 'paste raw html manually'
        redirect_to edit_html_path(part) and return
      elsif part
        redirect_to page_path(part) and return
      else
        flash[:alert] = 'cant add without url'
      end

    elsif params[:add_parent]
      @parent = @page.add_parent(params[:add_parent])
      # Rails.logger.debug "added #{@parent.inspect}"
      case @parent
      when Array
        flash[:alert] = 'More than one page with that title'
        @possibles = @parent
        render 'choose' and return
      when 'content'
        flash[:alert] = 'Parent with that title has content'
      when 'normalized'
        flash[:alert] = 'No page with that url'
      when Page
        flash[:notice] = 'Page added to this parent'
        @count = @page.position > Page::LIMIT ? @page.position - Page::LIMIT : 0
        @page = @parent
      end
    elsif params[:parent_id]
      position = @page.add_parent_with_id(params[:parent_id])
      flash[:notice] = 'Page added to this parent'
      @count = position > Page::LIMIT ? position - Page::LIMIT : 0
      @page = Page.find(params[:parent_id])
    else
      raise "missing or bad params (#{request.query_parameters})"
    end
    render 'pages/show' and return
  end
end
