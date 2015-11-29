class ItemsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    @items = @user.items

    @item = Item.new(item_params)
    @item.user = current_user
    @new_item = Item.new

    if @item.save
      flash[:notice] = "Success! Item was saved!"
    else
      flash[:error] = "Oops! Something went wrong. The item was not saved. Please try again!"
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # def index
  #   @items = Item.all
  # end

  # def show
  #   @item = Item.find(params[:id])
  # end

  # def newest
  #   @item = Item.new
  # end

  private

  def item_params
    params.require(:item).permit(:name)
  end

end
