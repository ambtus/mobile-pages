class Filter

  LIMIT = 10 # number of pages to show in index

  def self.tag(short_name, start)
    Rails.logger.debug "DEBUG: Filter.tag(#{short_name}, #{start})"
    tag = Tag.find_by_name(short_name)
    tag = Tag.find_by_short_name(short_name) unless tag
    tag.pages.order('read_after ASC').limit(start + LIMIT)[start..-1]
  end

  def self.new(params={})
    Rails.logger.debug "DEBUG: Filter.new(#{params})"
    pages = Page.all

    pages = pages.where(:type => (params[:type] == "none" ? nil : params[:type])) if params[:type] unless params[:type] == "all"

    # ignore parts unless asking for a type or a url or a title or a fandom or sorting on last_created
    # TODO should this be an if, instead of an unless? blacklist or whitelist?
    unless params[:type] || params[:url] || params[:title] || params[:fandom] || params[:sort_by] == "last_created"
      pages = pages.where(:parent_id => nil)
    end
    # ignore parts if filtering on size unless you've chosen a type
    pages = pages.where(:parent_id => nil) if params[:size] && !params[:type]

    pages = pages.where(:last_read => nil) if params[:unread] == "all"
    pages = pages.where(:last_read => [nil, Page::UNREAD_PARTS_DATE]) if params[:unread] == "any"
    pages = pages.where(:last_read => Page::UNREAD_PARTS_DATE) if params[:unread] == "parts"
    pages = pages.where.not(:last_read => [nil, Page::UNREAD_PARTS_DATE]) if params[:unread] == "none"

    pages = pages.where(:stars => params[:stars]) unless params[:stars].to_i == 0
    pages = pages.where(:stars => [5,4]) if params[:stars] == "better"
    pages = pages.where(:stars => [2,1]) if params[:stars] == "worse"
    pages = pages.where(:stars => [9]) if params[:stars] == "unfinished"

    pages = pages.where(:size => params[:size]) if Page::SIZES.include?(params[:size])
    pages = pages.where(:size => ["short", "drabble"]) if params[:size] == "shorter"
    pages = pages.where(:size => ["long", "epic"]) if params[:size] == "longer"

    [:title, :notes, :my_notes].each do |attrib|
      pages = pages.where("LOWER(pages.#{attrib.to_s}) LIKE ?", "%#{params[attrib].downcase}%") if params.has_key?(attrib)
    end

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
        pages.order(Arel.sql('RAND()'))
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

    tags=[]
    if params.has_key?(:hidden)
      tag = Hidden.find_by_short_name(params[:hidden])
      Rails.logger.debug "DEBUG: with #{tag.base_name}"
      tags << tag
    else
      pages = pages.where(hidden: false)
    end

    if params[:hide_all_cons] == "Yes"
      pages = pages.where(con: false)
    end

    Tag.types.each do |tag_type|
      if params.has_key?(tag_type.downcase.to_s)
        model = tag_type.constantize
        tag = model.find_by_short_name(params[tag_type.downcase.to_s])
        Rails.logger.debug "DEBUG: with #{model}s #{tag.base_name}"
        tags << tag
      end
    end

    if tags.size < 2
      if tags.size == 1
        if tags.first.type == "Con"
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
    Rails.logger.debug "DEBUG: filter on one or fewer tags"
    Rails.logger.debug "DEBUG: #{pages.to_sql}"
    start = params[:count].to_i
    pages.limit(start + LIMIT)[start..-1]
  end

  def self.intersection(pages, tags, params)
    Rails.logger.debug "DEBUG: filtering on intersection of #{tags.size} tags"
    results = []
    tags.each_with_index do |tag, index|
      if tag.type == "Con"
        pages_without_tag = pages - tag.pages
        Rails.logger.debug "DEBUG: not #{tag.base_name} has #{pages_without_tag.count} pages: #{pages_without_tag.map(&:title)}"
        results << pages_without_tag
      else
        pages_with_tag = pages.joins(:tags).distinct.where(tags: {id: tag.id})
        Rails.logger.debug "DEBUG: #{tag.base_name} has #{pages_with_tag.count} pages: #{pages_with_tag.map(&:title)}"
        results << pages_with_tag
      end
    end
    intersection = results.inject{|result, pages| result & pages}
    Rails.logger.debug "DEBUG: intersection has #{intersection.count} pages"
    start = params[:count].to_i
    intersection[start,LIMIT]
  end
end
