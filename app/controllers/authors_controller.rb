# frozen_string_literal: true

class AuthorsController < ApplicationController
  def index
    @title = 'Authors'
    @tags = Author.all
  end

  def show
    @tag = Author.find(params[:id])
    @title = @tag.base_name
  end
end
