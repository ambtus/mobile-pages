class PdfsController < ApplicationController
  def new
    @page = Page.find(params[:page_id])
  end

  def show
    page = Page.find(params[:page_id])
    font_size = params[:id] || Page::DEFAULT_PDF_FONT_SIZE
    file = page.pdf_file_name(font_size)
    page.to_pdf(font_size) unless File.exists?(file)
    send_file file, :type => Mime::PDF, :disposition => 'inline'
  end

  def create
    page = Page.find(params[:page_id])
    font_size = params[:font_size] || Page::DEFAULT_PDF_FONT_SIZE
    page.to_pdf(font_size)
    redirect_to page
  end

end
