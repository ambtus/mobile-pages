class NotesController < ApplicationController
  def edit
    @page = Page.find(params[:id])
  end
  def show
    @page = Page.find(params[:id])
  end
end
