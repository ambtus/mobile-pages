class ScrubsController < ApplicationController
  def show
    @page = Page.find(params[:id])
    if params[:notes]
      render :notes
    elsif @page.parts.blank?
      render :show
    else
      render :parts
    end
  end
end
