class DownloadsController < ApplicationController

  def show
    @page = Page.find(params[:id])
    FileUtils.mkdir_p @page.download_dir
    render_html

    respond_to do |format|
      format.html {
        send_file("#{@page.download_basename}.html", :type => "text/html", :disposition => 'inline')
      }
      # html for reading
      format.read {
        render_sections
        send_file("#{@page.download_basename}.read", :type => "text/html", :disposition => 'inline')
      }
      # epub for iBooks
      format.epub {
        @page.make_first
        @page.create_epub
        send_file("#{@page.download_basename}.epub", :type => "application/epub")
      }
    end
  end

protected

  ### render html

  def render_html
    return if File.exists?("#{@page.download_basename}.html")

    # render template
    html = render_to_string(:template => "downloads/show", :formats => [:html], :layout => 'downloads.html')

    # write to file
    File.open("#{@page.download_basename}.html", 'w') {|f| f.write(html)}
  end

  def render_sections
    return if File.exists?("#{@page.download_basename}.read")

    # render template
    html = render_to_string(:template => "downloads/read", :formats => [:html], :layout => 'downloads.html')

    # write to file
    File.open("#{@page.download_basename}.read", 'w') {|f| f.write(html)}
  end

end
