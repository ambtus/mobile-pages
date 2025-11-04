# frozen_string_literal: true

class Filter
  LIMIT = 5 # number of pages to show in index

  class << self
    # basic find by tag
    def tag(name, start)
      Rails.logger.debug { "Filter.tag(#{name}, #{start})" }
      tag = Tag.find_by(name: name)
      tag ||= Tag.with_short_name(name)
      tag.pages.order(:read_after).limit(start + LIMIT)[start..]
    end

    # all the sub-filters used when calling Filter.new
    def setup_filter(params = {})
      Rails.logger.debug { 'Filter.setup_filter' }
      pages = Page.all

      # ignore parts unless filering by type
      pages = pages.where(parent_id: nil) unless params[:type] || params[:child]
      pages
    end

    def by_mine(pages, params)
      Rails.logger.debug { 'Filter.by_mine' }
      return pages if pages.blank?

      case params[:favorite]
      when 'Yes'
        pages = pages.favorite
      when 'No'
        pages = pages.where(favorite: false)
      end

      case params[:soon]
      when 'Other'
        pages = pages.where.not(soon: [0, 1, 2, 3, 4])
      when nil
      else
        index = PageSoon::LABELS.index(params[:soon])
        pages = pages.where(soon: index)
      end

      case params[:unread]
      when 'Unread'
        pages = pages.unread
      when 'Parts'
        pages = pages.unread_parts
      when 'Read'
        pages = pages.read
      end

      case params[:stars]
      when 'other'
        pages = pages.where.not(stars: [10, 5, 4, 3])
      when nil
      else
        pages = pages.where(stars: params[:stars])
      end
      pages
    end

    def by_theirs(pages, params)
      Rails.logger.debug { 'Filter.by_theirs' }

      case params[:wip]
      when 'Yes'
        pages = pages.wip
      when 'No'
        pages = pages.where(wip: false)
      end

      case params[:child]
      when 'Yes'
        pages = pages.has_parent
      when 'No'
        pages = pages.has_no_parent
      end

      case params[:type]
      when 'none'
        pages = pages.where(type: nil)
      when nil
      when 'all'
      when 'taggable'
        pages = pages.with_tags
      else
        pages = pages.where(type: params[:type])
      end

      case params[:size]
      when 'Shorter'
        pages = pages.where(size: %w[short drabble])
      when 'Longer'
        pages = pages.where(size: %w[long epic])
      when nil
      else
        pages = pages.where(size: params[:size])
      end

      Rails.logger.debug { pages.class }
      pages
    end

    def by_strings(pages, params)
      Rails.logger.debug { 'Filter.by_strings' }

      pages = pages.where('pages.url LIKE ?', "%#{params[:url].normalize}%") if params.key?(:url)

      %i[title notes my_notes].each do |attrib|
        if params.key?(attrib)
          pages = pages.where("LOWER(pages.#{attrib}) LIKE ?",
  "%#{params[attrib].downcase}%")
        end
      end
      pages
    end

    def sort_by(pages, params)
      Rails.logger.debug { 'Filter.sort_by' }
      return pages if pages.blank?

      case params[:sort_by]
      when 'last_read'
        pages.order(last_read: :desc)
      when 'first_read'
        pages.where.not(pages: { last_read: nil }).order(:last_read)
      when 'random'
        pages.random
      when 'last_created'
        pages.order(created_at: :desc)
      when 'first_created'
        pages.order(:created_at)
      when 'longest'
        pages.order(wordcount: :desc)
      when 'shortest'
        pages.order(:wordcount)
      else
        pages.order(:read_after)
      end
    end

    def by_tags(pages, params)
      Rails.logger.debug { 'Filter.by_tags' }
      Tag.boolean_types.map(&:downcase).each do |tag_type|
        if params[:"show_#{tag_type}s"] == 'none'
          Rails.logger.debug { "no #{tag_type}s" }
          pages = pages.where(tag_type.to_sym => false)
        elsif params[:"show_#{tag_type}s"] == 'all'
          Rails.logger.debug { "all #{tag_type}s" }
          pages = pages.where(tag_type.to_sym => true)
        end
      end

      Tag.types.each do |tag_type|
        next unless params.key?(tag_type.downcase.to_s)

        model = tag_type.constantize
        tag = model.with_short_name(params[tag_type.downcase.to_s])
        if params.key?("selected_#{tag_type.downcase}s")
          if params["selected_#{tag_type.downcase}s"] == 'include'
            Rails.logger.debug { "include by choice #{model}s #{tag.base_name}" }
            pages = pages.where('pages.tag_cache LIKE ?', "%#{tag.base_name}%")
          elsif params["selected_#{tag_type.downcase}s"] == 'exclude'
            Rails.logger.debug { "exclude by choide #{model}s #{tag.base_name}" }
            pages = pages.where.not('pages.tag_cache LIKE ?', "%#{tag.base_name}%")
          end
        else
          Rails.logger.debug { "include by default #{model}s #{tag.base_name}" }
          pages = pages.where('pages.tag_cache LIKE ?', "%#{tag.base_name}%")
        end
      end

      if params.key?('tag')
        tag = Tag.with_short_name(params['tag'])
        Rails.logger.debug { "with Tag #{tag.base_name} (originally from find)" }
        pages = pages.where('pages.tag_cache LIKE ?', "%#{tag.base_name}%")
      end
      pages
    end

    def all(params)
      pages = setup_filter(params)
      pages = by_mine(pages, params)
      pages = by_theirs(pages, params)
      pages = by_strings(pages, params)
      pages = sort_by(pages, params)
      by_tags(pages, params)
    end

    def new(params = {})
      Rails.logger.debug { "Filter on #{params.symbolize_keys}" }
      pages = all(params)

      start = params[:count].to_i
      pages.limit(start + LIMIT)[start..]
    end
  end
end
