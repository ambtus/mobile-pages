class StoreController < ApplicationController
  def new
    @page = Page.new
  end
end
