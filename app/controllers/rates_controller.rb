class RatesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    Rails.logger.debug "DEBUG: Rate.create(#{params.to_unsafe_h.symbolize_keys})"
    page = Page.find(params[:page_id])
    interesting = params[:interesting]
    nice = params[:nice]
    case params[:commit]
      when "Rate"
        unless interesting && nice
          flash[:alert] = "You must select both ratings"
          redirect_to rate_path(page) and return
        end
        rating = page.rate(interesting, nice)
        if rating == 0
          flash[:notice] = "#{page.title} set for reading again in 6 months"
        else
          flash[:notice] = "#{page.title} set for reading again in #{rating} years"
        end
        redirect_to pages_url
      when "Rate unfinished"
        if interesting && nice
          page.rate(interesting, nice)
        end
        page.make_unfinished
        flash[:notice] = "#{page.title} set to 'unfinished'"
        redirect_to pages_url
    end
  end
end
