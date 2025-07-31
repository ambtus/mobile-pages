# frozen_string_literal: true

class MyNotesController < ApplicationController
  def edit
    @page = Page.find(params[:id])
  end
end
