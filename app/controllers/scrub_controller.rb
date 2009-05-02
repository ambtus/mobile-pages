class ScrubController < ApplicationController
  def show
    @page = Page.find(params[:id])
    if @page.parts.blank?
      render :show
    else
      render :parts
    end
  end
end
