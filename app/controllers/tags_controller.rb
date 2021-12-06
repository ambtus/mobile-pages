class TagsController < ApplicationController
  def index
    @tags = Tag.all
  end

  def show
    if params[:destroy]
      @tag = Tag.find(params[:id])
      render :destroy and return
    elsif params[:recache]
      @tag = Tag.find(params[:id])
      Rails.logger.debug "DEBUG: recaching pages"
      @tag.recache
      render :edit and return
    else
      Rails.logger.debug "DEBUG: selecting tags"
      @page = Page.find(params[:id])
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
    elsif params[:commit] == "Split"
      if params[:first_tag_name] == params[:second_tag_name]
        flash.now[:alert] = "can't split: names must be different"
        render :edit and return
      end
      both_new = Tag.find_by_name(params[:first_tag_name]).nil? && Tag.find_by_name(params[:second_tag_name]).nil?
      if both_new
        @tag.update!(name: params[:first_tag_name])
        new_tag = Tag.create!(name: params[:second_tag_name], type: @tag.type )
        @tag.pages.each{|p| p.tags << new_tag unless p.tags.include?(new_tag)}
        @tag.pages.map(&:cache_tags)
        redirect_to tags_path and return
      end
      first = Tag.find_by_name(params[:first_tag_name]) || (@tag.update(name: params[:first_tag_name]) && @tag)
      second = Tag.find_by_name(params[:second_tag_name]) || (@tag.update(name: params[:second_tag_name]) && @tag)
      @tag.pages.each do |page|
        page.tags << first unless page.tags.include?(first)
        page.tags << second unless page.tags.include?(second)
      end
      if @tag != first && @tag != second
        @tag.destroy_me
      else
        @tag.pages.map(&:cache_tags)
      end
      redirect_to tags_path and return
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
