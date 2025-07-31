# frozen_string_literal: true

class HtmlsController < ApplicationController
  def edit
    @page = Page.find(params[:id])
    return unless params[:format] == 'scrubbed'

    render 'scrubbed' and return
  end
end
