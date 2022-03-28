class RefetchesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Refetch Meta"
      Rails.logger.debug "DEBUG: refetching meta for #{@page.id}"
      @page.refetch_meta
      @notice = "Refetched meta"
    elsif params[:url].present?
      @page.refetch(params[:url])
      @notice = "Refetched"
    else
      @page.refetch_parts(params[:url_list])
      @notice = "Refetched parts"
    end
    flash[:alert] = @page.errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    flash[:notice] = @notice
    Rails.logger.debug "DEBUG: flash: #{flash.collect {|n, m| n+m}}"
    @page = Page.find(params[:page_id]) # in case its class changed during refetch
    @count = @page.parts.size > Page::LIMIT ? @page.parts.size - Page::LIMIT : 0
    render 'pages/show'
  end
end
