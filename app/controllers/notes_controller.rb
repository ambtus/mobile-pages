# frozen_string_literal: true

class NotesController < ApplicationController
  def show
    @page = Page.find(params[:id])
  end

  def edit
    @page = Page.find(params[:id])
  end
end
