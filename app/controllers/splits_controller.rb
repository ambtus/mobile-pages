# frozen_string_literal: true

class SplitsController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end

  def create
    @page = Page.find(params[:id])
    node_number = params[:split_node].to_i
    case params[:commit]
    when 'Children'
      @page.create_children(node_number)
    when 'Sibling'
      @page.create_sibling(node_number)
    end
    redirect_to page_path(@page)
  end
end
