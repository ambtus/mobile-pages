class HiddensController < ApplicationController
  def index
    @hiddens = Hidden.all
  end
  def show
    if params[:destroy]
      @hidden = Hidden.find(params[:id])
      render :destroy and return
    end
    @page = Page.find(params[:id])
    if Hidden.count == 0 || params[:add]
      render :new
    else
      render :select
    end
  end
  def edit
    @hidden = Hidden.find(params[:id])
    @hiddens = Hidden.all
  end
  def update
    @hidden = Hidden.find(params[:id])
    if params[:commit] == "Merge"
      new_hidden = Hidden.find_by_name(params[:merge])
      if new_hidden == @hidden
        flash.now[:alert] = "can't merge with self"
        render :edit and return
      end
      if new_hidden.nil?
        flash.now[:alert] = "can't merge with non-existant hidden"
        render :edit and return
      end
      new_hidden.pages << @hidden.pages
      @hidden.destroy_me
      redirect_to :root
    elsif params[:commit] == "Move to Genre"
      @hidden.make_genre
      redirect_to :root
    elsif @hidden.update_attributes(params[:hidden])
      redirect_to :root
    else
      render :edit
    end
  end
  def create
    @page = Page.find(params[:page_id])
    if params[:commit] == "Update Hidden Genres"
      hidden_ids = params[:page][:hidden_ids] if params[:page]
      @page.hidden_ids = hidden_ids
      @page.cache_hiddens
    elsif params[:commit] == "Add Hidden Genres"
      @page.add_hiddens_from_string = params[:hiddens]
    end
    redirect_to page_path(@page)
  end
  def destroy
    @hidden = Hidden.find(params[:id])
    @hidden.destroy_me
    redirect_to :root
  end
end
