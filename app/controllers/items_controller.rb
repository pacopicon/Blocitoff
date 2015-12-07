class ItemsController < ApplicationController

  def show
    @item = current_user.items.find(params[:id])
    @items = current_user.items

    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    @item = current_user.items.find(params[:id])

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
    @user = current_user
    @item = current_user.items.build(item_params)
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
    params.require(:item).permit(:name, :completed)
  end

end
