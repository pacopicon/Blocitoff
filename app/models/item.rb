class Item < ActiveRecord::Base
  belongs_to :user
  has_many :rankings

  default_scope {order('rank DESC')}

  after_create :update_rank

  include BigMath

  require 'bigdecimal'
  require 'bigdecimal/math'
  require 'bigdecimal/util'
  require 'complex'

  # the first argument is the importance rating, the second argument is an exponent variable which allows for the rating functions to approach the y axis steeply so as to give due_date increasing weight in the ranking priority as due_date draws near -- all the while time_est can modify the rank as well.
  def rank_algo(imp_rank, exp)
    @new_rank = ((((@due_date_rating + imp_rank)/2)**exp)/@big_div).real.round
  end

  def update_rank
    # Taking hour and minute from time_est and breaking it down to seconds:
    time_est_in_secs = ((time_est.hour * 60 * 60) + (time_est.min * 60)).to_f
    # No. of seconds till the due date
    t_till_date = due_date.to_f - DateTime.now.to_f
    # The rating is a year in seconds plus time estimate in seconds minus due date in seconds
    @due_date_rating = ((31449600 + time_est_in_secs - t_till_date) / 100000).to_f
    # This is a contingency that bumps up tasks that are due soon
    urgent = (t_till_date <= time_est_in_secs + 3600) == true
    # the big_div is to whittle numbers down into a comprehensible amount of digits
    @big_div = 10**20

    if !urgent && importance == "I'll get fired if I don't do this"
      rank_algo(400, 9.6)
    elsif !urgent && importance == "pretty important"
      rank_algo(358, 9.7)
    elsif !urgent && importance == "important"
      rank_algo(319.25, 9.8)
    elsif !urgent && importance == "of trivial importance"
      rank_algo(283.45, 9.9)
    elsif !urgent && importance == "not important at all"
      rank_algo(283.39, 9.9)
    else
      rank_algo(400, 10)
    end
      update_attribute(:rank, @new_rank)
  end

  # def completeness
  #   if self.
  #
  #   else
  #   end
  #   update_attribute(:item_completeness, item_completeness)
  # end

end
