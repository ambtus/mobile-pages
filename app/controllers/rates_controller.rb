class RatesController < ApplicationController

  def show
    @page = Page.find(params[:id])
    @stars = @page.stars.to_s
  end

  def create
    Rails.logger.debug "DEBUG: Rate.create(#{params.to_unsafe_h.symbolize_keys})"
    page = Page.find(params[:page_id])
    stars = params[:stars]
    case params[:commit]
      when "Rate"
        unless stars
          flash[:alert] = "You must select stars"
          redirect_to rate_path(page) and return
        end
        page.rate_today(stars)
        redirect_to edit_rate_path(page)
      when "Rate unfinished"
        flash[:alert] = "Selected stars ignored" if stars
        page.rate_unfinished_today
        redirect_to edit_rate_path(page)
      when "Rate all unrated parts"
        unless stars
          flash[:alert] = "You must select stars"
          redirect_to rate_path(page) and return
        end
        page.rate_all_unrated_today(stars)
        redirect_to edit_rate_path(page)
    end
  end

  def edit
    @page = Page.find(params[:id])
    @some = true
  end

end
