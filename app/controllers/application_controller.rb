# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  def consolidate_tag_ids
    if params[:page]
      Rails.logger.debug 'consolidate_tag_ids'
      tag_ids = Tag.types.map do |type|
        params[:page].delete("#{type.downcase}_ids")
      end
      params[:page][:tag_ids] = tag_ids.flatten.compact
      Rails.logger.debug { "tag_ids=#{params[:page][:tag_ids]}" }
    else
      params[:page] = { tag_ids: [] }
      Rails.logger.debug 'no tag ids'
    end
  end

  def create_pages_from_search(url)
    raw_html = Scrub.fetch_html(url)
    work_list = raw_html.scan(/work-(\d+)/).flatten.uniq
    Scrub.get_ao3_works_from_list(work_list)
  end
end
