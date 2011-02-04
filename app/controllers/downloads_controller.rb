class DownloadsController < ApplicationController

  def show
    @page = Page.find(params[:id])
    @page_title = @page.title
    @page.make_first
    @parts = @page.parts
    FileUtils.mkdir_p @page.download_dir
    raise unless File.exist?(@page.download_dir)

    respond_to do |format|
      format.html {download_html}
      # big pdf for GoodReader on iphone (size 55, no margins)
      format.bigpdf {download_bigpdf}
      # pdf for GoodReader on iPad (size 24)
      format.pdf {download_pdf}
      # mobipocket for Kindle
      format.mobi {download_mobi}
      # epub for iBooks
      format.epub {download_epub}
      # text for BookZ
      format.txt {download_text}
    end
  end

protected

  # used after an external program is called to make sure it worked
  def check_for_file(format)
    unless File.exists?("#{@page.download_basename}#{format}")
      flash[:alert] = "Creating this format failed. Please try another format"
      redirect_to @page
      false
    end
  end

  ### basic create and download methods

  def create_html
    return if File.exists?("#{@page.download_basename}.html")

    # render template
    html = render_to_string(:template => "downloads/show.html", :layout => 'downloads.html')

    # write to file
    File.open("#{@page.download_basename}.html", 'w') {|f| f.write(html)}
  end

  def download_html
    create_html

    # send as HTML
    send_file("#{@page.download_basename}.html", :type => "text/html")
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

  def download_text
    create_text

    # send as text
    send_file("#{@page.download_basename}.txt", :type => "text/plain")
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

  def download_pdf
    create_pdf

    # send as pdf
    return unless check_for_file(".pdf")
    send_file("#{@page.download_basename}.pdf", :type => "application/pdf")
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

  def download_bigpdf
    create_bigpdf

    # send as big pdf
    return unless check_for_file("-big.pdf")
    send_file("#{@page.download_basename}-big.pdf", :type => "application/pdf")
  end

  def create_mobi
     # double quotes in title need to be escaped
     title = @page.title.gsub(/"/, '\"')

     cmd_pre = %Q{cd "#{@page.download_dir}"; html2mobi }
     cmd_post = %Q{ --mobifile "#{@page.download_title}.mobi" --title "#{title}" }

    # if only one part can use same file as html and pdf versions
    if @parts.size == 1
      create_html

      # except mobi requires latin1 encoding
      unless File.exists?("#{@page.download_dir}/mobi.html")
        html = Iconv.conv("LATIN1//TRANSLIT//IGNORE", "UTF8",
                 File.read("#{@page.download_basename}.html")).force_encoding("ISO-8859-1")
        File.open("#{@page.download_dir}/mobi.html", 'w') {|f| f.write(html)}
      end

      # convert latin html to mobi
      cmd = cmd_pre + "mobi.html" + cmd_post
    else
      # more than one part
      # create a table of contents out of separate part files
      mobi_files = create_mobi_files
      cmd = cmd_pre + mobi_files + " --gentoc" + cmd_post
    end
    Rails.logger.debug cmd
    `#{cmd} 2> /dev/null`
  end

  def download_mobi
    create_mobi

    # send as mobi
    return unless check_for_file(".mobi")
    send_file("#{@page.download_basename}.mobi", :type => "application/mobi")
  end

  def create_epub
    # if only one part can use same file as html and pdf versions
    if @parts.size == 1
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

  def download_epub
    create_epub

    # send the file
    return unless check_for_file(".epub")
    send_file("#{@page.download_basename}.epub", :type => "application/epub")
  end

  ### extra methods for mobi and epub

  def create_mobi_files
    return if File.exists?("#{@page.download_basename}.mobi")
    FileUtils.mkdir_p "#{@page.download_dir}/mobi"

    # the preface contains meta tag information, the title/author, work summary and work notes
    @page_title = "Preface"
    render_mobi_html("_download_preface", "preface")

    # each part may have its own byline, notes and endnotes
    @parts.each_with_index do |part, index|
       @part = part
       @page_title = part.title
       render_mobi_html("_download_part", "part#{index+1}")
    end

    part_file_names = 1.upto(@parts.size).map {|i| "mobi/part#{i}.html"}
    ["mobi/preface.html", part_file_names.join(' ')].join(' ')
  end

  def render_mobi_html(template, basename)
    @mobi = true
    html = render_to_string(:template => "downloads/#{template}.html", :layout => 'downloads.html')
    html = Iconv.conv("ASCII//TRANSLIT//IGNORE", "UTF8", html)
    File.open("#{@page.download_dir}/mobi/#{basename}.html", 'w') {|f| f.write(html)}
  end

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
      preface = render_to_string(:template => "downloads/_download_preface.html", :layout => 'downloads.html')
      render_xhtml(preface, "preface")

      @parts.each_with_index do |part, index|
        @part = part
        html = render_to_string(:template => "downloads/_download_part.html", :layout => "downloads.html")
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
