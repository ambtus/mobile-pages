class TagsController < ApplicationController
  def index
    @title = "Tags"
    @tags = Tag.all
  end

  def show
    if params[:destroy]
      @tag = Tag.find(params[:id])
      render :destroy and return
    elsif params[:recache]
      @tag = Tag.find(params[:id])
      if @tag.type == "Hidden"
        Rails.logger.debug "recaching pages"
        @tag.pages.update_all hidden: true
        render :edit and return
      elsif @tag.type == "Con"
        Rails.logger.debug "recaching pages"
        @tag.pages.update_all con: true
        render :edit and return
      else
        flash.now[:alert] = "can't recache non-hiddens"
      end
    else
      Rails.logger.debug "selecting tags"
      @page = Page.find(params[:id])
      render :select
    end
  end

  def edit
    @tag = Tag.find(params[:id])
    @title = "Edit tag: #{@tag.name}"
    @tags = Tag.all
  end

  def update
    @tag = Tag.find(params[:id])
    if params[:commit] == "Merge"
      Rails.logger.debug "merging tags #{@tag.name} and #{params[:merge]}"
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
      if true_tag.is_a?(Author)
        redirect_to author_path(true_tag)
      elsif true_tag.is_a?(Fandom)
        redirect_to fandom_path(true_tag)
      else
        redirect_to tags_path + "##{@tag.class}"
      end
    elsif params[:commit] == "Change"
      old_type = @tag.class
      new_type = params[:change]
      @tag.update_attribute(:type, new_type)
      old_type.recache_all
      new_type.constantize.recache_all
      @tag.pages.map(&:remove_outdated_downloads)
      if new_type == 'Author'
        redirect_to author_path(@tag)
      elsif new_type == 'Fandom'
        redirect_to fandom_path(@tag)
      else
        redirect_to tags_path + "##{new_type}"
      end
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
        @tag.pages.map(&:save!)
        redirect_to tags_path + "##{@tag.class}" and return
      end
      first = Tag.find_by_name(params[:first_tag_name]) || (@tag.update(name: params[:first_tag_name]) && @tag)
      second = Tag.find_by_name(params[:second_tag_name]) || (@tag.update(name: params[:second_tag_name]) && @tag)
      @tag.pages.each do |page|
        Rails.logger.debug "adding #{first.name} to #{page.title}"
        page.tags << first unless page.tags.include?(first)
        Rails.logger.debug "adding #{second.name} to #{page.title}"
        page.tags << second unless page.tags.include?(second)
        page.save!
      end
      neither_new = (@tag != first && @tag != second)
      if neither_new
        Rails.logger.debug "removing #{@tag.name}"
        # don't need to destroy_me, because replacements have already been added to the affected pages
        @tag.destroy
      end
      if first.is_a?(Author)
        redirect_to authors_path
      elsif first.is_a?(Fandom)
        redirect_to fandoms_path
      else
        redirect_to tags_path + "##{@tag.class}" and return
      end
    elsif params[:commit] == "Update"
      old_basename = @tag.base_name
      @tag.update_attribute(:name, params[:tag][:name])
      @tag.pages.map(&:remove_outdated_downloads)
      if @tag.base_name != old_basename
        Rails.logger.debug "changed base name requires rechache from #{old_basename} to #{@tag.base_name}"
        @tag.pages.map(&:save!)
      end
      if @tag.is_a?(Author)
        redirect_to author_path(@tag)
      elsif @tag.is_a?(Fandom)
        redirect_to fandom_path(@tag)
      else
        redirect_to tags_path + "##{@tag.class}" and return
      end
    else
      render :edit
    end
  end

  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Update Tags"
      consolidate_tag_ids
      @page.tag_ids = params[:page][:tag_ids]
      @page.save!
      @page.parts.map(&:save!) if @page.can_have_parts?
      @page.parent.save! if @page.parent
    elsif params[:commit].match /Add (.*) Tags/
      unless @page.add_tags_from_string(params[:tags], $1.squish)
        Rails.logger.debug "page errors: #{@page.errors.messages}"
        flash[:alert] = @page.errors.collect {|error| "#{error.attribute.to_s.humanize unless error.attribute == :base} #{error.message}"}.join(" and  ")
        redirect_to tag_path(@page.id) and return
      end
    end
    @page.save!
    redirect_to page_path(@page)
  end

  def destroy
    @tag = Tag.find(params[:id])
    klass = @tag.class
    @tag.destroy_me
    if klass == Author
      redirect_to authors_path
    elsif klass == Fandom
      redirect_to fandoms_path
    else
      redirect_to tags_path + "##{klass}"
    end
  end
end
