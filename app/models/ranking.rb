class Ranking < ActiveRecord::Base
  belongs_to :item

  after_save :update_item

  private

  def update_item
    item.update_rank
  end

end
