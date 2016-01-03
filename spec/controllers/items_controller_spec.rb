require 'rails_helper'

describe ItemsController do

  include TestFactories
  include Devise::TestHelpers

  before do
    @user = authenticated_userc
  end

  describe "#create" do
    it "creates an item" do
      expect(@user.items.find_by_user_id(@user.id).to be_nil

      post :create, {user_id: @user.id}

      expect(@user.items.find_by_user_id(@user.id).not_to be_nil
    end
  end

  describe "#destroy" do
    it "destroys the item" do
      @item = @user.items.create
      expect(@user.items.find_by_user_id(@user.id).not_to be_nil

      delete :destroy, {user_id: @user.id, id: @item.id}

      expect(@user.items.find_by_user_id(@user.id).to be_nil
    end
  end

end
