# encoding=utf-8

class Chapter < Page

  def fetch_ao3
    Rails.logger.debug "fetch_ao3 chapter #{self.id}"
    fetch_raw && set_meta
  end

end
