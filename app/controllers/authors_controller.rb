class AuthorsController < ApplicationController
  def index; end
  def show
    if params[:destroy].present?
      @author = Author.find(params[:id])
      Rails.logger.debug "DEBUG: deleting author #{@author.name}"
      render :destroy and return
    else
      @page = Page.find(params[:id])
      Rails.logger.debug "DEBUG: updatings authors for #{@page.title}"
      if Author.count == 0 || params[:add]
        render :new
      else
        render :select
      end
    end
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Update Authors"
      author_ids = params[:page][:author_ids] if params[:page]
      @page.author_ids = author_ids
    elsif params[:commit] == "Add Authors"
      @page.add_author_string = params[:authors]
    end
    redirect_to page_path(@page)
  end
  def edit
    @author = Author.find(params[:id])
  end
  def destroy
    @author = Author.find(params[:id])
    @author.destroy_me
    redirect_to authors_path
  end
  def update
    @author = Author.find(params[:id])
    if params[:commit] == "Update"
      Rails.logger.debug "DEBUG: update name for author from #{@author.name} to #{params[:author][:name]}"
      @author.update_attribute(:name, params[:author][:name])
      redirect_to authors_path
    elsif params[:commit] == "Merge"
      true_author = Author.find_by_short_name(params[:merge])
      if true_author == @author
        flash.now[:alert] = "can't merge with self"
        render :edit and return
      end
      if true_author.nil?
        flash.now[:alert] = "can't merge with non-existant author"
        render :edit and return
      end
      true_author.add_aka(@author)
      redirect_to authors_path
    end
  end
end
