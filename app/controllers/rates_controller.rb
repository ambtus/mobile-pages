class RatesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end
  def create
    page = Page.find(params[:page_id])
    interesting = params[:interesting]
    nice = params[:nice]
    unless interesting && nice
      flash[:alert] = "You must select both ratings"
      redirect_to rate_path(page) and return
    end
    rating = page.update_rating(interesting, nice)
    case params[:commit]
      when "Rate"
        if rating == 0
          flash[:notice] = "#{page.title} set for reading again in 6 months"
        else
          flash[:notice] = "#{page.title} set for reading again in #{rating} years"
        end
        redirect_to pages_url
      when "Rate reading"
        page.make_reading
        flash[:notice] = "#{page.title} set to 'reading'"
        redirect_to pages_url
    end
  end
end
