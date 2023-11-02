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

    if params[:soon]
      if params[:soon] == "Now"
        pages = pages.where(soon: [-1,0,1,2])
      elsif params[:soon] == "Never"
        pages = pages.where(soon: [3,4,5])
      else
        index = Soon::LABELS.index(params[:soon]) -1
        pages = pages.where(soon: index)
      end
    end

    pages = pages.where(:type => (params[:type] == "none" ? nil : params[:type])) if params[:type] unless params[:type] == "all"

    # ignore parts unless asking for a type or a url or a title or a fandom or sorting on last_created
    # TODO should this be an if, instead of an unless? blacklist or whitelist?
    unless params[:type] || params[:url] || params[:audio_url] || params[:title] || params[:fandom] || params[:sort_by] == "last_created"
      pages = pages.where(:parent_id => nil)
    end
    # ignore parts if filtering on size unless you've chosen a type
    pages = pages.where(:parent_id => nil) if params[:size] && !params[:type]

    pages = pages.where(:last_read => nil) if params[:unread] == "Unread"
    pages = pages.where(:last_read => Page::UNREAD_PARTS_DATE) if params[:unread] == "Parts"
    pages = pages.where.not(:last_read => [nil, Page::UNREAD_PARTS_DATE]) if params[:unread] == "Read"

    pages = pages.where(:stars => params[:stars]) unless params[:stars].to_i == 0
    pages = pages.where(:stars => [5,4]) if params[:stars] == "Better"
    pages = pages.where(:stars => [2,1]) if params[:stars] == "Worse"
    pages = pages.where(:stars => [9]) if params[:stars] == "unfinished"

    pages = pages.where(:size => params[:size]) if Page::SIZES.include?(params[:size])
    pages = pages.where(:size => ["short", "drabble"]) if params[:size] == "Shorter"
    pages = pages.where(:size => ["long", "epic"]) if params[:size] == "Longer"

    [:title, :notes, :my_notes].each do |attrib|
      pages = pages.where("LOWER(pages.#{attrib.to_s}) LIKE ?", "%#{params[attrib].downcase}%") if params.has_key?(attrib)
    end

    pages = pages.where("pages.audio_url LIKE ?", "%#{params[:audio_url]}%") unless params[:audio_url].blank?

    if params.has_key?(:url) # strip the https? in case it was stored under the other
      pages = pages.where("pages.url LIKE ?", "%#{params[:url].sub(/^https?/, '')}%")
    end

    pages = case params[:sort_by]
      when "last_read"
        pages.order('last_read DESC')
      when "first_read"
        pages = pages.where('pages.last_read is not null')
        pages.order('last_read ASC')
      when "random"
        pages.random
      when "last_created"
        pages.order('created_at DESC')
      when "first_created"
        pages.order('created_at ASC')
      when "longest"
        pages.order('wordcount DESC')
      when "shortest"
        pages.order('wordcount ASC')
      else
        pages.order('read_after ASC')
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

   tags=[]
   Tag.types.each do |tag_type|
      if params.has_key?(tag_type.downcase.to_s)
        model = tag_type.constantize
        tag = model.find_by_short_name(params[tag_type.downcase.to_s])
        Rails.logger.debug "with #{model}s #{tag.base_name}"
        tags << tag
      end
    end

    if params.has_key?("tag")
      tag = Tag.find_by_short_name(params["tag"])
      Rails.logger.debug "with Tag #{tag.base_name} (originally from find)"
      tags << tag
    end

    if params.has_key?('omit')
      Filter.omitted(pages, tags, params)
    elsif tags.size < 2
      if tags.size == 1
        if tags.first.type == "Con" && !params.has_key?("tag")
          Filter.intersection(pages, tags, params)
        else
          pages = pages.joins(:tags).where(tags: {id: tags.first.id}).distinct
          Filter.normal(pages, params)
        end
      elsif tags.empty?
        Filter.normal(pages, params)
      end
    elsif tags.size > 1
      Filter.intersection(pages, tags, params)
    end
  end

  def self.normal(pages, params)
    Rails.logger.debug "filter on one or fewer tags"
    Rails.logger.debug pages.to_sql
    start = params[:count].to_i
    pages.limit(start + LIMIT)[start..-1]
  end

  def self.intersection(pages, tags, params)
    Rails.logger.debug "filtering on intersection of #{tags.size} tags"
    results = []
    tags.each do |tag|
      if tag.type == "Con" && !params.has_key?("tag")
        pages_without_tag = pages - tag.pages
        Rails.logger.debug "not #{tag.base_name} has #{pages_without_tag.count} pages: #{pages_without_tag.map(&:title)}"
        results << pages_without_tag
      else
        pages_with_tag = pages.joins(:tags).distinct.where(tags: {id: tag.id})
        Rails.logger.debug "#{tag.base_name} has #{pages_with_tag.count} pages: #{pages_with_tag.map(&:title)}"
        results << pages_with_tag
      end
    end
    intersection = results.inject{|result, pages| result & pages}
    Rails.logger.debug "intersection has #{intersection.count} pages"
    start = params[:count].to_i
    intersection[start,LIMIT]
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
end
