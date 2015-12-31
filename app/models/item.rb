class Item < ActiveRecord::Base
  belongs_to :user
  after_save :update_rank

  def update_rank
    time_est_in_secs = time_est.to_i
    t_till_date = (due_date - DateTime.now).to_i
    due_date_rating = 31449600 - t_till_date

    if t_till_date <= time_est_in_secs + 3600
      new_rank = 31449600 * 7
    else
      new_rank = due_date_rating * importance
    end
     update_attribute(:rank, new_rank)
   end

  default_scope { order('rank DESC') }

end
