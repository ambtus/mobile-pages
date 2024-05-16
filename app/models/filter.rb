class Filter

  LIMIT = 5 # number of pages to show in index

  def self.tag(name, start)
    Rails.logger.debug "Filter.tag(#{name}, #{start})"
    tag = Tag.find_by_name(name)
    tag = Tag.find_by_short_name(name) unless tag
    tag.pages.order('read_after ASC').limit(start + LIMIT)[start..-1]
  end

  def self.new(params={})
    Rails.logger.debug "Filter.new(#{params})"
    pages = Page.all

    # ignore parts if haven't made any choices at all
    if params.blank? || params.without(:count).blank?
      pages = pages.where(:parent_id => nil)
    end

    case params[:soon]
    when "Now"
      pages = pages.where(soon: [0,1,2])
    when "Never"
      pages = pages.where(soon: [3,4])
    when nil
    else
      index = Soon::LABELS.index(params[:soon])
      pages = pages.where(soon: index)
    end

    case params[:type]
    when "none"
      pages = pages.where(type: nil)
    when "all"
    when nil
      # ignore parts if filtering on size unless you've chosen a size
      pages = pages.where(:parent_id => nil) if params[:size]
    else
      pages = pages.where(type: params[:type])
    end

    case params[:unread]
    when "Unread"
      pages = pages.where(:last_read => nil)
      # ignore parts if filtering on unread unless you've chosen a type
      pages = pages.where(:parent_id => nil) unless params[:type]
    when "Parts"
      pages = pages.where(:last_read => Page::UNREAD_PARTS_DATE)
    when "Read"
      pages = pages.where.not(:last_read => [nil, Page::UNREAD_PARTS_DATE])
      # ignore parts if filtering on unread unless you've chosen a type
      pages = pages.where(:parent_id => nil) unless params[:type]
    end

    case params[:stars]
    when "Better"
      pages = pages.where(:stars => [5,4])
    when "other"
      pages = pages.where.not(:stars => [10,5,4,3])
    when nil
    else
      pages = pages.where(:stars => params[:stars])
    end

    case params[:size]
    when "Shorter"
      pages = pages.where(:size => ["short", "drabble"])
    when "Longer"
      pages = pages.where(:size => ["long", "epic"])
    when nil
    else
      pages = pages.where(:size => params[:size])
    end

    [:title, :notes, :my_notes].each do |attrib|
      pages = pages.where("LOWER(pages.#{attrib.to_s}) LIKE ?", "%#{params[attrib].downcase}%") if params.has_key?(attrib)
    end

    [:url, :audio_url].each do |attrib|
      pages = pages.where("pages.#{attrib.to_s} LIKE ?", "%#{params[attrib].normalize}%") if params.has_key?(attrib)
    end

    case params[:sort_by]
    when "last_read"
      pages = pages.order('last_read DESC')
    when "first_read"
      pages = pages.where('pages.last_read is not null').order('last_read ASC')
    when "random"
      pages = pages.random
    when "last_created"
      pages = pages.order('created_at DESC')
    when "first_created"
      pages = pages.order('created_at ASC')
    when "longest"
      pages = pages.order('wordcount DESC')
      # ignore parts if filtering on length unless you've chosen a type
      pages = pages.where(:parent_id => nil) unless params[:type]
    when "shortest"
      pages = pages.order('wordcount ASC')
      # ignore parts if filtering on length unless you've chosen a type
      pages = pages.where(:parent_id => nil) unless params[:type]
    else
      pages = pages.order('read_after ASC')
    end

    case params[:show_audios]
    when "none"
      Rails.logger.debug "no audios"
      pages = pages.where(audio_url: nil)
    when "all"
      pages = pages.where.not(audio_url: nil)
    end

    Tag.boolean_types.map(&:downcase).each do |tag_type|
      if params["show_#{tag_type}s".to_sym] == "none"
        Rails.logger.debug "no #{tag_type}s"
        pages = pages.where(tag_type.to_sym => false)
      elsif params["show_#{tag_type}s".to_sym] == "all"
        Rails.logger.debug "all #{tag_type}s"
        pages = pages.where(tag_type.to_sym => true)
      end
    end

    if params[:tag_cache]
      tags = params[:tag_cache].split_comma
      Rails.logger.debug "tags #{tags} in tag cache"
      tags.each do |tag|
        pages = pages.where("pages.tag_cache LIKE ?", "%#{tag}%")
      end
    end

   excluded=[]
   included=[]
   Tag.types.each do |tag_type|
      if params.has_key?(tag_type.downcase.to_s)
        model = tag_type.constantize
        tag = model.find_by_short_name(params[tag_type.downcase.to_s])
        if params.has_key?("selected_#{tag_type.downcase}s".to_s)
          if params["selected_#{tag_type.downcase}s".to_s]=="include"
            Rails.logger.debug "include by choice #{model}s #{tag.base_name}"
            included << tag
          elsif params["selected_#{tag_type.downcase}s".to_s]=="exclude"
            Rails.logger.debug "exclude by choide #{model}s #{tag.base_name}"
            excluded << tag
          end
        else
          Rails.logger.debug "include by default #{model}s #{tag.base_name}"
          included << tag
        end
      end
    end

    if params.has_key?("tag")
      tag = Tag.find_by_short_name(params["tag"])
      Rails.logger.debug "with Tag #{tag.base_name} (originally from find)"
      included << tag
    end

    if included.size < 2 && excluded.empty?
      if included.size == 1
        pages = pages.joins(:tags).where(tags: {id: included.first.id}).distinct
        Filter.normal(pages, params)
      elsif included.empty?
        Filter.normal(pages, params)
      end
    elsif included.empty? && excluded.size >0
      Filter.omitted(pages, excluded, params)
    else
      Filter.intersection(pages, included, excluded, params)
    end
  end

  def self.normal(pages, params)
    Rails.logger.debug "filter on one or fewer tags"
    Rails.logger.debug pages.to_sql
    start = params[:count].to_i
    pages.limit(start + LIMIT)[start..-1]
  end

  def self.omitted(pages, tags, params)
    Rails.logger.debug "filtering without #{tags.size} tags"
    Rails.logger.debug "start with #{pages.count} pages"
    results = []
    tags.each do |tag|
      pages = pages - tag.pages
    end
    Rails.logger.debug "end with #{pages.count} pages"
    start = params[:count].to_i
    pages[start,LIMIT]
  end

  def self.intersection(pages, included, excluded, params)
    Rails.logger.debug "filtering on included #{included.size} and excluded #{excluded} tags"
    results = []
    excluded.each do |tag|
      pages_without_tag = pages - tag.pages
      Rails.logger.debug "not #{tag.base_name} has #{pages_without_tag.count} pages: #{pages_without_tag.map(&:title)}"
      results << pages_without_tag
    end
    included.each do |tag|
      pages_with_tag = pages.joins(:tags).distinct.where(tags: {id: tag.id})
      Rails.logger.debug "#{tag.base_name} has #{pages_with_tag.count} pages: #{pages_with_tag.map(&:title)}"
      results << pages_with_tag
    end
    intersection = results.inject{|result, pages| result & pages}
    Rails.logger.debug "intersection has #{intersection.count} pages"
    start = params[:count].to_i
    intersection[start,LIMIT]
  end

end
