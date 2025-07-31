# frozen_string_literal: true

class ReadersController < ApplicationController
  def index
    @title = 'Readers'
    @tags = Reader.all
  end

  def show
    @tag = Reader.find(params[:id])
    @title = @tag.base_name
  end
end
