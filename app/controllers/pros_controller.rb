# frozen_string_literal: true

class ProsController < ApplicationController
  def index
    @title = 'Pros'
    @tags = Pro.all
  end

  def show
    @tag = Pro.find(params[:id])
    @title = @tag.base_name
  end
end
