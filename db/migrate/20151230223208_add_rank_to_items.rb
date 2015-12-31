class AddRankToItems < ActiveRecord::Migration
  def change
    add_column :items, :rank, :float
  end
end
