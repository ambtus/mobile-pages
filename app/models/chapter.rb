# encoding=utf-8
# frozen_string_literal: true

class Chapter < Page
  def fetch_ao3
    Rails.logger.debug { "fetch_ao3 chapter #{id}" }
    fetch_raw && set_meta
  end
end
