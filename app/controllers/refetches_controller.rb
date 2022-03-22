class RefetchesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @notice = "Refetched"
    @page = Page.find(params[:page_id])
    if params[:commit] == "Refetch Meta"
      Rails.logger.debug "DEBUG: refetching meta for #{@page.id}"
      @page.parts.each do |part|
        part.get_meta_from_ao3
      end
      @page.get_meta_from_ao3
      @notice = "Refetched meta"
    elsif @page.ao3? && @page.is_a?(Single) && !@page.ao3_chapter?
        @page = @page.becomes!(Book)
        @page.fetch_ao3
    elsif params[:url].present?
      @page.update!(url: params[:url])
      Rails.logger.debug "DEBUG: refetching all for #{@page.id} url: #{@page.url}"
      if @page.ao3?
        @page = @page.becomes!(@page.ao3_type)
        @page.fetch_ao3
     elsif @page.ff?
        @page.errors.add(:base, "can't refetch from fanfiction.net")
        @notice = ""
      else
        @page.fetch_raw
      end
    else
      Rails.logger.debug "DEBUG: refetching all for #{@page.id} url_list: #{params[:url_list]}"
      @page.parts_from_urls(params[:url_list])
    end
    flash[:alert] = @page.errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    flash[:notice] = @notice
    Rails.logger.debug "DEBUG: flash: #{flash.collect {|n, m| n+m}}"
    redirect_to :controller => 'pages', :action => 'show', :id => @page.id
  end
end
