# frozen_string_literal: true

class DownloadsController < ApplicationController
  def show
    @url = 'http://mp.ambt.us'
    @page = Page.find(params[:id])
    @title = @page.title
    FileUtils.mkdir_p @page.download_dir

    respond_to do |format|
      # html for reading inline
      format.html do
        render_html
        send_file("#{@page.download_basename}.html", type: 'text/html', disposition: 'inline')
      end
      # html for reading aloud inline for audiobooks
      format.read do
        Rails.logger.debug { "sending sectioned for #{@page.id}" }
        render_sections
        send_file("#{@page.download_basename}.read", type: 'text/html', disposition: 'inline')
      end
      # epub for downloading to read offline
      format.epub do
        render_html
        @page.set_reading unless @page.hidden?
        @page.create_epub
        send_file("#{@page.download_basename}.epub", type: 'application/epub')
      end
    end
  end

  protected

  ### render html

  def render_html
    return if File.exist?("#{@page.download_basename}.html")

    # write to file
    File.write("#{@page.download_basename}.html",
render_to_string(template: 'downloads/show', formats: [:html], layout: 'downloads'))
  end

  def render_sections
    return if File.exist?("#{@page.download_basename}.read")

    # write to file
    File.write("#{@page.download_basename}.read",
render_to_string(template: 'downloads/read', formats: [:html], layout: 'downloads'))
  end
end
