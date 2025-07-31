# frozen_string_literal: true

class FandomsController < ApplicationController
  def index
    @title = 'Fandoms'
    @tags = Fandom.all
  end

  def show
    @tag = Fandom.find(params[:id])
    @title = @tag.base_name
  end
end
