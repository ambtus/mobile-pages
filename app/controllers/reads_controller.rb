class ReadsController < ApplicationController
  
  def show
    @page = Page.find(params[:id])
  end

end
