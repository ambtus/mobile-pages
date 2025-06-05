class CollectionsController < ApplicationController
  def index
    @title = "Collections"
    @tags = Collection.all
  end

  def show
    @tag = Collection.find(params[:id])
    @title = @tag.base_name
  end
end
