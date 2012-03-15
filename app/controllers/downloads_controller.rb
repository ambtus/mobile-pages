class DownloadsController < ApplicationController

  def show
    @page = Page.find(params[:id])
    @page_title = @page.title
    @page.make_first
    @parts = @page.parts
    FileUtils.mkdir_p @page.download_dir

    respond_to do |format|
      format.html {
        create_html
        file_created?(".html") && send_file("#{@page.download_basename}.html", :type => "text/html", :disposition => 'inline')
      }
      # big pdf for GoodReader on iphone (size 55, no margins)
      format.bigpdf {
        create_bigpdf
        file_created?("-big.pdf") && send_file("#{@page.download_basename}-big.pdf", :type => "application/pdf")
      }
      # pdf for GoodReader on iPad (size 24)
      format.pdf {
        create_pdf
        file_created?(".pdf") && send_file("#{@page.download_basename}.pdf", :type => "application/pdf")
      }
      # epub for iBooks
      format.epub {
        create_epub
        file_created?(".epub") && send_file("#{@page.download_basename}.epub", :type => "application/epub")
      }
      # text for BookZ
      format.txt {
        create_text
        file_created?(".txt") && send_file("#{@page.download_basename}.txt", :type => "text/plain", :disposition => 'inline')
      }
    end
  end

protected

  # test to see if the file exists before sending it
  def file_created?(suffix)
    if File.exists?("#{@page.download_basename}#{suffix}")
      true
    else
      flash[:alert] = "Creating this format failed. Please try another format"
      false
    end
  end

  ### basic create methods

  def create_html
    return if File.exists?("#{@page.download_basename}.html")

    # render template
    html = render_to_string(:template => "downloads/show", :formats => [:html], :layout => 'downloads.html')

    # write to file
    File.open("#{@page.download_basename}.html", 'w') {|f| f.write(html)}
  end

  def create_text
    return if File.exists?("#{@page.download_basename}.txt")

    # make sure html exists
    create_html

    # convert html to text
    html = File.open("#{@page.download_basename}.html").read
    body = Nokogiri::HTML(html).xpath('//body').first.inner_html
    text = Scrub.html_to_text(body)
    File.open("#{@page.download_basename}.txt", 'w:utf-8') { |f| f.write(text) }
  end

  def create_pdf
    return if File.exists?("#{@page.download_basename}.pdf")

    # make sure html exists
    create_html

    # convert html to pdf
    # double quotes in title need to be escaped
    title = @page.title.gsub(/"/, '\"')
    cmd = %Q{cd "#{@page.download_dir}"; wkhtmltopdf --encoding utf-8 --minimum-font-size 24 --title "#{title}" "#{@page.download_title}.html" "#{@page.download_title}.pdf"}
    Rails.logger.debug cmd
    `#{cmd} 2> /dev/null`
  end

  def create_bigpdf
    return if File.exists?("#{@page.download_basename}-big.pdf")

    # make sure html exists
    create_html

    # convert html to bigpdf
    # double quotes in title need to be escaped
    title = @page.title.gsub(/"/, '\"')
    cmd = %Q{cd "#{@page.download_dir}"; wkhtmltopdf --encoding utf-8 -B 0 -L 0 -R 0 -T 0 --minimum-font-size 55 --title "#{title}" "#{@page.download_title}.html" "#{@page.download_title}-big.pdf"}
    Rails.logger.debug cmd
    `#{cmd} 2> /dev/null`
  end

  def create_epub
    # if only one part can use same file as html and pdf versions
    if @parts.size == 0
      create_epub_files("single")
    else
      create_epub_files
    end

    # stuff contents of epub directory into a zip file named with .epub extension
    # note: we have to zip this up in this particular order because "mimetype" must be the first item in the zipfile
    cmd = %Q{cd "#{@page.download_dir}/epub"; zip "#{@page.download_basename}.epub" mimetype; zip -r "#{@page.download_basename}.epub" META-INF OEBPS}
    Rails.logger.debug cmd
   `#{cmd} 2> /dev/null`
  end

  ### extra methods for epub

  def create_epub_files(single = "")
    return if File.exists?("#{@page.download_basename}.epub")
  # Manually building an epub file here
  # See http://www.jedisaber.com/eBooks/tutorial.asp for details
    epubdir = "#{@page.download_dir}/epub"
    FileUtils.mkdir_p epubdir

    # copy mimetype and container files which don't need processing
    FileUtils.cp("#{Rails.root}/app/views/epub/mimetype", epubdir)
    FileUtils.mkdir_p "#{epubdir}/META-INF"
    FileUtils.cp("#{Rails.root}/app/views/epub/container.xml", "#{epubdir}/META-INF")

    # write the OEBPS navigation files
    FileUtils.mkdir_p "#{epubdir}/OEBPS"
    File.open("#{epubdir}/OEBPS/toc.ncx", 'w') {|f| f.write(render_to_string(:file => "#{Rails.root}/app/views/epub/toc.ncx#{single}"))}
    File.open("#{epubdir}/OEBPS/content.opf", 'w') {|f| f.write(render_to_string(:file => "#{Rails.root}/app/views/epub/content.opf#{single}"))}

    # write the OEBPS content files
    if single == "single"
      # can use work html, but needs translation into proper xhtml
      create_html
      render_xhtml(File.read("#{@page.download_basename}.html"), "work")
    else
      preface = render_to_string(:template => "downloads/_download_preface", :format => [:html], :layout => 'downloads.html')
      render_xhtml(preface, "preface")

      @parts.each_with_index do |part, index|
        @part = part
        html = render_to_string(:template => "downloads/_download_part", :format => [:html], :layout => "downloads.html")
        render_xhtml(html, "part#{index + 1}")
      end

    end
  end

  def render_xhtml(html, filename)
    doc = Nokogiri::XML.parse(html)
    xhtml = doc.children.to_xhtml
    File.open("#{@page.download_dir}/epub/OEBPS/#{filename}.xhtml", 'w') {|f| f.write(xhtml)}
  end

end
