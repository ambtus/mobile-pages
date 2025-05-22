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

    # ignore parts unless filering by type
    pages = pages.where(:parent_id => nil) unless (params[:type] || params[:child])

    case params[:favorite]
    when "Yes"
      pages = pages.favorite
    when "No"
      pages = pages.where(favorite: false)
    end

    case params[:wip]
    when "Yes"
      pages = pages.wip
    when "No"
      pages = pages.where(wip: false)
    end

    case params[:child]
    when "Yes"
      pages = pages.has_parent
    when "No"
      pages = pages.has_no_parent
    end

    case params[:soon]
    when "Other"
      pages = pages.where.not(soon: [0,1,2,3,4])
    when nil
    else
      index = Soon::LABELS.index(params[:soon])
      pages = pages.where(soon: index)
    end

    case params[:type]
    when "none"
      pages = pages.where(type: nil)
    when nil
    when "all"
    when 'taggable'
      pages = pages.with_tags
    else
      pages = pages.where(type: params[:type])
    end

    case params[:unread]
    when "Unread"
      pages = pages.unread
    when "Parts"
      pages = pages.unread_parts
    when "Read"
      pages = pages.read
    end

    case params[:stars]
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

    pages = pages.where("pages.url LIKE ?", "%#{params[:url].normalize}%") if params.has_key?(:url)

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
    when "shortest"
      pages = pages.order('wordcount ASC')
    else
      pages = pages.order('read_after ASC')
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

   Tag.types.each do |tag_type|
      if params.has_key?(tag_type.downcase.to_s)
        model = tag_type.constantize
        tag = model.find_by_short_name(params[tag_type.downcase.to_s])
        if params.has_key?("selected_#{tag_type.downcase}s".to_s)
          if params["selected_#{tag_type.downcase}s".to_s]=="include"
            Rails.logger.debug "include by choice #{model}s #{tag.base_name}"
            pages = pages.where("pages.tag_cache LIKE ?", "%#{tag.base_name}%")
          elsif params["selected_#{tag_type.downcase}s".to_s]=="exclude"
            Rails.logger.debug "exclude by choide #{model}s #{tag.base_name}"
            pages = pages.where.not("pages.tag_cache LIKE ?", "%#{tag.base_name}%")
          end
        else
          Rails.logger.debug "include by default #{model}s #{tag.base_name}"
          pages = pages.where("pages.tag_cache LIKE ?", "%#{tag.base_name}%")
        end
      end
    end

    if params.has_key?("tag")
      tag = Tag.find_by_short_name(params["tag"])
      Rails.logger.debug "with Tag #{tag.base_name} (originally from find)"
      pages = pages.where("pages.tag_cache LIKE ?", "%#{tag.base_name}%")
    end

    start = params[:count].to_i
    pages.limit(start + LIMIT)[start..-1]
  end

end
