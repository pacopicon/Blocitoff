class AddImportanceToItems < ActiveRecord::Migration
  def change
    add_column :items, :importance, :integer
  end
end
