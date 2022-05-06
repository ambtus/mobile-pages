# encoding=utf-8

class Chapter < Page

  def fetch_ao3
    Rails.logger.debug "DEBUG: fetch_ao3 chapter #{self.id}"
    fetch_raw && set_meta
  end

end
