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
      if @tag.type == "Hidden"
        Rails.logger.debug "DEBUG: recaching pages"
        @tag.pages.update_all hidden: true
        render :edit and return
      elsif @tag.type == "Con"
        Rails.logger.debug "DEBUG: recaching pages"
        @tag.pages.update_all con: true
        render :edit and return
      else
        flash.now[:alert] = "can't recache non-hiddens"
      end
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
      Rails.logger.debug "DEBUG: merging tags #{@tag.name} and #{params[:merge]}"
      true_tag = @tag.class.find_by_short_name(params[:merge])
      if true_tag == @tag
        flash.now[:alert] = "can't merge with self"
        render :edit and return
      end
      if true_tag.nil?
        flash.now[:alert] = "can't merge with non-existant tag"
        render :edit and return
      end
      true_tag.add_aka(@tag)
      redirect_to tags_path + "##{@tag.class}"
    elsif params[:commit] == "Change"
      was_hidden = @tag.type == "Hidden"
      was_con = @tag.type == "Con"
      type = params[:change]
      @tag.update_attribute(:type, type)
      if type == "Hidden"
        Rails.logger.debug "DEBUG: setting #{@tag.pages.size} #{@tag.name}'s pages to hidden"
        @tag.pages.update_all hidden: true
      elsif type == "Con"
        Rails.logger.debug "DEBUG: setting #{@tag.pages.size} #{@tag.name}'s pages to conned"
        @tag.pages.update_all con: true
      end
      if was_hidden
        Rails.logger.debug "DEBUG: may be unhiding #{@tag.name}'s pages"
        @tag.pages.map(&:reset_hidden)
      elsif was_con
        Rails.logger.debug "DEBUG: may be unconning #{@tag.name}'s pages"
        @tag.pages.map(&:reset_con)
      end
      @tag.pages.map(&:remove_outdated_downloads)
      redirect_to tags_path + "##{@tag.class}"
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
        redirect_to tags_path + "##{@tag.class}" and return
      end
      first = Tag.find_by_name(params[:first_tag_name]) || (@tag.update(name: params[:first_tag_name]) && @tag)
      second = Tag.find_by_name(params[:second_tag_name]) || (@tag.update(name: params[:second_tag_name]) && @tag)
      @tag.pages.each do |page|
        Rails.logger.debug "DEBUG: adding #{first.name} to #{page.title}"
        page.tags << first unless page.tags.include?(first)
        Rails.logger.debug "DEBUG: adding #{second.name} to #{page.title}"
        page.tags << second unless page.tags.include?(second)
      end
      neither_new = (@tag != first && @tag != second)
      if neither_new
        Rails.logger.debug "DEBUG: removing #{@tag.name}"
        # don't need to destroy_me, because replacements have already been added to the affected pages
        @tag.destroy
      end
      redirect_to tags_path + "##{@tag.class}" and return
    elsif params[:commit] == "Update"
      @tag.update_attribute(:name, params[:tag][:name])
      @tag.pages.map(&:remove_outdated_downloads)
      redirect_to tags_path + "##{@tag.class}"
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
    elsif params[:commit].match /Add (.*) Tags/
      @page.add_tags_from_string(params[:tags], $1.squish)
    end
    @page.reset_con
    @page.reset_hidden
    redirect_to page_path(@page)
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy_me
    redirect_to tags_path + "##{@tag.class}"
  end
end
