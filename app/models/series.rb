# encoding=utf-8
# frozen_string_literal: true

class Series < Page
  def fetch_ao3
    Rails.logger.debug { "fetch_ao3 series #{id}" }
    fetch_raw && get_works_from_ao3 && set_meta && update_from_parts
  end

  def get_works_from_ao3
    work_list = raw_html.scan(/work-(\d+)/).flatten.uniq
    Rails.logger.debug { "work list for #{id}: #{work_list}" }
    Scrub.get_ao3_works_from_list(work_list, self)
    true
  end
end
