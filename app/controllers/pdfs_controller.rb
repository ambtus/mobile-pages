class PdfsController < ApplicationController
  def new
    @page = Page.find(params[:page_id])
  end

  def show
    page = Page.find(params[:page_id])
    font_size = params[:id] || Page::DEFAULT_PDF_FONT_SIZE
    file = page.pdf_file_name(font_size)
    unless File.exists?(file)
      redirect_to new_page_pdf_path, :alert => "Pdf doesn't exist" and return
    end
    send_file file, :type => Mime::PDF, :disposition => 'inline'
  end

  def create
    page = Page.find(params[:page_id])
    font_size = params[:font_size] || Page::DEFAULT_PDF_FONT_SIZE
    redirect_to page, :notice => "Large files may take a while to process"
    page.to_pdf(font_size)
  end

end
