class RefetchesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Refetch Meta"
      @page.parts.each do |part|
        part.get_meta_from_ao3
      end
      @page.get_meta_from_ao3
    elsif @page.parts.blank? || @page.ao3?
      @page.update_attribute(:url, params[:url])
      if @page.ao3?
        @page.refetch_ao3
      elsif @page.ff?
        @page.errors.add(:base, "can't refetch from fanfiction.net")
      else
        @page.fetch
      end
    else
      @page.parts_from_urls(params[:url_list], true)
    end
    flash[:alert] = @page.errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
    redirect_to page_path(@page)
  end
end
