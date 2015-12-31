class AddTimeEstToItems < ActiveRecord::Migration
  def change
    add_column :items, :time_est, :time
  end
end
