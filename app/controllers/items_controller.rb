class ItemsController < ApplicationController

  def show
    @user = current_user
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

  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      flash[:notice] = "item has been updated."
    else
      flash[:error] = "There was an error pdating the item. Please try again!"
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :completed, :due_date, :time_est, :importance)
  end

end
