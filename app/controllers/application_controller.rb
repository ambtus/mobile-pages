class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  def consolidate_tag_ids
    tag_ids = []
    Tag.types.each do |type|
      tag_ids << params[:page].delete(type.downcase + "_ids")
    end
    params[:page][:tag_ids] = tag_ids.flatten.compact
    Rails.logger.debug "tag_ids=#{params[:page][:tag_ids]}"
  end
end
