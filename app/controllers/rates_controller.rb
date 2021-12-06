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
        page.parent.cleanup if page.parent
        redirect_to tag_path(page)
      when "Rate unfinished"
        flash[:alert] = "Selected stars ignored" if stars
        page.make_unfinished
        page.parent.cleanup if page.parent
        redirect_to tag_path(page)
      when "Rate all unrated parts"
        unless stars
          flash[:alert] = "You must select stars"
          redirect_to rate_path(page) and return
        end
        page.rate_unread(stars)
        page.cleanup
        redirect_to tag_path(page)
      when "Rate all unrated parts unfinished"
        flash[:alert] = "Selected stars ignored" if stars
        page.unread_parts.map(&:make_unfinished)
        page.cleanup
        redirect_to tag_path(page)
    end
  end

end
