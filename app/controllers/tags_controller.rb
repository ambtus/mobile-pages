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
    render :select
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
        page.tags << new_tag unless page.tags.include?(new_tag)
      end
      @tag.destroy_me
      redirect_to tags_path
    elsif params[:commit] == "Change"
      type = params[:change]
      type = "" if type == "Trope"
      rechache = (type == "Hidden" || @tag.type == "Hidden")
      @tag.update_attribute(:type, type)
      rechache ? @tag.pages.map(&:cache_tags) : @tag.pages.map(&:remove_outdated_downloads)
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
      tag_ids = []
      Tag.types.each do |type|
        symbol = "#{type.downcase}_ids".to_sym
        tag_ids = tag_ids + params[:page][symbol] if (params[:page] && params[:page][symbol])
      end
      Rails.logger.debug "DEBUG: replacing tags for #{@page.id} with #{tag_ids}"
      @page.tag_ids = tag_ids
      @page.cache_tags
    elsif params[:commit].match /Add (.*) Tags/
      @page.add_tags_from_string(params[:tags], $1.squish)
    end
    redirect_to page_path(@page)
  end
  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy_me
    redirect_to tags_path
  end
end
