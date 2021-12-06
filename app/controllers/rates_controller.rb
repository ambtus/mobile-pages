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
        page.read_today.rate(stars).update_read_after
        redirect_to tag_path(page)
      when "Rate unfinished"
        flash[:alert] = "Selected stars ignored" if stars
        page.make_unfinished
        redirect_to tag_path(page)
      when "Rate all unrated parts"
        unless stars
          flash[:alert] = "You must select stars"
          redirect_to rate_path(page) and return
        end
        page.rate_unread(stars)
        redirect_to tag_path(page)
      when "Rate all unrated parts unfinished"
        flash[:alert] = "Selected stars ignored" if stars
        page.unread_parts.map(&:make_unfinished)
        page.update_last_read.update_stars.update_read_after
        redirect_to tag_path(page)
    end
  end

end
