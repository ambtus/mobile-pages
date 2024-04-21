class DownloadsController < ApplicationController

  def show
    @url = "http://mp.ambt.us"
    @page = Page.find(params[:id])
    @title = @page.title
    FileUtils.mkdir_p @page.download_dir
    render_html

    respond_to do |format|
      # html for reading inline
      format.html {
        send_file("#{@page.download_basename}.html", :type => "text/html", :disposition => 'inline')
      }
      # html for reading aloud inline for audiobooks
      format.read {
        Rails.logger.debug "sending sectioned for #{@page.id}"
        render_sections
        send_file("#{@page.download_basename}.read", :type => "text/html", :disposition => 'inline')
      }
      # epub for downloading to read offline
      format.epub {
        @page.set_reading unless @page.hidden?
        @page.create_epub
        send_file("#{@page.download_basename}.epub", :type => "application/epub")
      }
    end
  end

protected

  ### render html

  def render_html
    return if File.exists?("#{@page.download_basename}.html")

    # write to file
    File.open("#{@page.download_basename}.html", 'w') {|f| f.write(render_to_string(:template => "downloads/show", :formats => [:html], :layout => 'downloads'))}
  end

  def render_sections
    return if File.exists?("#{@page.download_basename}.read")

    # write to file
    File.open("#{@page.download_basename}.read", 'w') {|f| f.write(render_to_string(:template => "downloads/read", :formats => [:html], :layout => 'downloads'))}
  end

end
