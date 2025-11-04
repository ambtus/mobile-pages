# frozen_string_literal: true

class RefetchesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == 'Refetch Recursive'
      Rails.logger.debug { "refetching meta for #{@page.id}" }
      if @page.ao3?
        Rails.logger.debug { "refetching all parts for #{@page.id}" }
        @page.refetch_recursive
      else
        @page.parts_from_urls(params[:url_list], refetch: true)
      end
      @notice = 'Refetched all'
    elsif params[:url].present? && params[:url] != 'URL'
      if params[:NoFetch].present?
        Rails.logger.debug { "updating url with #{params[:url]} for #{@page.id}" }
        @page.update(url: params[:url])
        @notice = 'Stored'
      else
        Rails.logger.debug { "refetching with #{params[:url]} for #{@page.id}" }
        @page = @page.refetch(params[:url])
        @notice = 'Refetched'
      end
    elsif params[:NoFetch].present?
      Rails.logger.debug { "storing new part urls for #{@page.id}" }
      @page.parts_from_urls(params[:url_list], refetch: false)
      @notice = 'Stored part urls'
    else
      Rails.logger.debug { "refetching parts for #{@page.id}" }
      @page.parts_from_urls(params[:url_list])
      @notice = 'Refetched parts'
    end
    if @page.errors.present?
      Rails.logger.debug { "page errors: #{@page.errors.messages}" }
      flash.now[:alert] = @page.errors.collect do |error|
        "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"
      end.join(' and  ')
    else
      flash.now[:notice] = @notice
    end
    @page = Page.find(@page.id) # in case page changed during refetch
    @count = @page.parts.size > Page::LIMIT ? @page.parts.size - Page::LIMIT : 0
    render 'pages/show'
  end
end
