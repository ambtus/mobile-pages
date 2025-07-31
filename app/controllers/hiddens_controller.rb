# frozen_string_literal: true

class HiddensController < ApplicationController
  def index
    @title = 'Hiddens'
    @tags = Hidden.all
  end

  def show
    @tag = Hidden.find(params[:id])
    @title = @tag.base_name
  end
end
