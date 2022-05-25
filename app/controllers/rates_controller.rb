class RatesController < ApplicationController

  def show
    @page = Page.find(params[:id])
    @stars = @page.stars.to_s
  end

  def create
    Rails.logger.debug "Rate.create(#{params.to_unsafe_h.symbolize_keys})"
    page = Page.find(params[:page_id])
    stars = params[:stars]
    unless stars
      flash[:alert] = "You must select stars"
      redirect_to rate_path(page) and return
    end
    page.rate_today(stars, params[:all])
    page.update_cliff(params[:cliff])
    page.reset_soon
    redirect_to edit_rate_path(page)
  end

  def edit
    @page = Page.find(params[:id])
    @some = true
  end

end
