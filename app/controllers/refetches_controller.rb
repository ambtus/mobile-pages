class RefetchesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Refetch Recursive"
      Rails.logger.debug "refetching meta for #{@page.id}"
      if @page.ao3?
        Rails.logger.debug "refetching all parts for #{@page.id}"
        @page.refetch_recursive
      else
        @page.parts_from_urls(params[:url_list], true)
      end
      @notice = "Refetched all"
    elsif params[:url].present? && params[:url] != "URL"
      Rails.logger.debug "refetching with #{params[:url]} for #{@page.id}"
      @page = @page.refetch(params[:url])
      @notice = "Refetched"
    else
      Rails.logger.debug "refetching parts for #{@page.id}"
      @page.parts_from_urls(params[:url_list])
      @notice = "Refetched new parts"
    end
    unless @page.errors.blank?
      Rails.logger.debug "page errors: #{@page.errors.messages}"
      flash[:alert] = @page.errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    end
    flash[:notice] = @notice
    @page = Page.find(@page.id) # in case it changed during refetch
    @count = @page.parts.size > Page::LIMIT ? @page.parts.size - Page::LIMIT : 0
    render 'pages/show'
  end
end
