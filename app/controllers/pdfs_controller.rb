class PdfsController < ApplicationController
  def new
    @page = Page.find(params[:page_id])
    @pdf_files = @page.pdf_files.map {|f| File.basename(f, '.pdf') }
  end

  def show
    page = Page.find(params[:page_id])
    font_size = params[:id] || Page::DEFAULT_PDF_FONT_SIZE
    file = page.pdf_file_name(font_size)
    unless File.exists?(file)
      redirect_to new_page_pdf_path, :alert => "Pdf doesn't exist" and return
    end
    if ENV['RAILS_ENV'] == 'production'
      redirect_to page.pdf_file_basename(font_size)
    else
      send_file "#{file}", :type => Mime::PDF, :disposition => 'inline'
    end
  end

  def create
    page = Page.find(params[:page_id])
    if params[:commit] == "Remove all pdfs"
      page.destroy_all_pdfs
      redirect_to page, :notice => "All pdfs removed"
    else
      font_size = params[:font_size] || Page::DEFAULT_PDF_FONT_SIZE
      redirect_to page, :notice => "Large files may take a while to process"
      page.to_pdf(font_size)
    end
  end

end
