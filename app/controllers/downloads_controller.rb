# frozen_string_literal: true

class DownloadsController < ApplicationController
  def show
    page = Page.find(params[:id])

    respond_to do |format|
      # html for reading inline
      format.html do
        page.render_html
        send_file(page.temporary_file('.html'), type: 'text/html', disposition: 'inline')
      end
      # html for reading aloud inline for audiobooks
      format.read do
        page.render_read_aloud
        send_file(page.temporary_file('.read'), type: 'text/html', disposition: 'inline')
      end
      # epub for downloading to read offline
      format.epub do
        page.render_epub
        page.set_reading unless page.hidden?
        send_file(page.temporary_file('.epub'), type: 'application/epub')
      end
    end
  end
end
