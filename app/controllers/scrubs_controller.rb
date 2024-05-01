class ScrubsController < ApplicationController
  def show
    @page = Page.find(params[:id])
    if params[:notes]
      render :notes
    elsif @page.can_have_parts?
      render :parts
    else
      render :show
    end
  end
end
