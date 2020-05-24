class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end
  def show
    if params[:destroy]
      @tag = Tag.find(params[:id])
      render :destroy and return
    end
    @page = Page.find(params[:id])
    if Tag.count == 0 || params[:add]
      render :new
    else
      render :select
    end
  end
  def edit
    @tag = Tag.find(params[:id])
    @tags = Tag.all
  end
  def update
    @tag = Tag.find(params[:id])
    if params[:commit] == "Merge"
      new_tag = Tag.find_by_name(params[:merge])
      if new_tag == @tag
        flash.now[:alert] = "can't merge with self"
        render :edit and return
      end
      if new_tag.nil?
        flash.now[:alert] = "can't merge with non-existant tag"
        render :edit and return
      end
      @tag.pages.each do |page|
        page.tags << new_tag
      end
      @tag.destroy_me
      redirect_to tags_path
    elsif params[:commit] == "Change"
      @tag.update_attribute(:type, params[:change])
      @tag.pages.map(&:cache_tags)
      redirect_to tags_path
    elsif params[:commit] == "Update"
      @tag.update_attribute(:name, params[:tag][:name])
      @tag.pages.map(&:cache_tags)
      redirect_to tags_path
    else
      render :edit
    end
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Update Tags"
      tag_ids = params[:page][:tag_ids] if params[:page]
      @page.tag_ids = tag_ids
      @page.cache_tags
    elsif params[:commit] == "Add Tags"
      @page.add_tags_from_string(params[:tags])
    elsif params[:commit] == "Add Hidden Tags"
      @page.add_hiddens_from_string(params[:tags])
    end
    redirect_to page_path(@page)
  end
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy_me
    redirect_to :root
  end
end
