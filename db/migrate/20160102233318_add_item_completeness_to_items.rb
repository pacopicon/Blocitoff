class AddItemCompletenessToItems < ActiveRecord::Migration
  def change
    add_column :items, :item_completeness, :string
  end
end
