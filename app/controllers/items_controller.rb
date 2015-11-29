class ItemsController < ApplicationController

  def destroy
    @user = User.find(params[:user_id])
    @item = @user.items.find(params[:id])

    if @item.destroy
      flash[:notice] = "The item was obliterated!"
    else
      flash[:notice] = "Oops!, the item could not be deleted.  Try again!"
    end

  respond_to do |format|
    format.html
    format.js
  end
end

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

  private

  def item_params
    params.require(:item).permit(:name)
  end

end
