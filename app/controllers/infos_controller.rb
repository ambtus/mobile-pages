# frozen_string_literal: true

class InfosController < ApplicationController
  def index
    @title = 'Infos'
    @tags = Info.all
  end

  def show
    @tag = Info.find(params[:id])
    @title = @tag.base_name
  end
end
