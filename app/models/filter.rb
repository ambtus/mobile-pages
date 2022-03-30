class Filter

  LIMIT = 10 # number of pages to show in index

  def self.new(params={})
    Rails.logger.debug "DEBUG: Filter.new(#{params})"
    pages = Page.all
    pages = pages.where(:type => (params[:type] == "none" ? nil : params[:type])) if params[:type] unless params[:type] == "all"

    # ignore parts unless asking for a type or a url or a title or a fandom or sorting on last_created
    # TODO should this be an if, instead of an unless? blacklist or whitelist?
    unless params[:type] || params[:url] || params[:title] || params[:fandom] || params[:sort_by] == "last_created"
      pages = pages.where(:parent_id => nil)
    end
    # ignore parts if filtering on size
    pages = pages.where(:parent_id => nil) if params[:size]

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

    [:tag, :fandom, :character, :rating, :info].each do |tag_type|
      pages = pages.where("pages.cached_tag_string LIKE ?", "%#{params[tag_type]}%") if params.has_key?(tag_type)
    end

    pages = pages.where("pages.cached_tag_string NOT LIKE ?", "%#{params[:omitted]}%") if params.has_key?(:omitted)

    if params.has_key?(:hidden)
      pages = pages.where("pages.cached_hidden_string LIKE ?", "%#{params[:hidden]}%")
    elsif params.has_key?(:url)
      # do not constrain on cached_hidden_string if finding by url
    else
      pages = pages.where(:cached_hidden_string => "")
    end

    pages = pages.joins(:authors).where("authors.name LIKE ?", "%#{params[:author]}%") if params.has_key?(:author)

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

    start = params[:count].to_i
    pages.group(:id).limit(start + LIMIT)[start..-1]
  end

end
