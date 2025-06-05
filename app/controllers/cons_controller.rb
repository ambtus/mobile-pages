class ConsController < ApplicationController
  def index
    @title = "Cons"
    @tags = Con.all
  end

  def show
    @tag = Con.find(params[:id])
    @title = @tag.base_name
  end
end
