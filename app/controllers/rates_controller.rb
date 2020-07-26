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
        stars = page.rate(stars)
        if stars == 5
          flash[:notice] = "#{page.title} set for reading again in 6 months"
        else
          flash[:notice] = "#{page.title} set for reading again in #{page.read_after.year}"
        end
        redirect_to tag_path(page)
      when "Rate unfinished"
        flash[:alert] = "Selected stars ignored" if stars
        page.make_unfinished
        flash[:notice] = "#{page.title} marked 'unfinished' and set for reading again in #{page.read_after.year}"
        redirect_to tag_path(page)
    end
  end
end
