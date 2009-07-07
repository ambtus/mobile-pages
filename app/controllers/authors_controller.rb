class AuthorsController < ApplicationController
  def show
    @page = Page.find(params[:id])
    if Author.count == 0 || params[:add]
      render :new
    else
      render :select
    end
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Update Authors"
      author_ids = params[:page][:author_ids] if params[:page]
      @page.update_attribute(:author_ids, author_ids)
    elsif params[:commit] == "Add Authors"
      @page.add_author_string = params[:authors]
    end
    redirect_to page_path(@page)
  end
end
