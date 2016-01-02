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

  def update_rank
    time_est.strftime "%R"
    time_est_in_secs = time_est.to_f
    t_till_date = due_date.to_f - DateTime.now.to_f
    due_date_rating = ((31449600 - t_till_date) / 100000).to_f
    urgent = (t_till_date <= time_est_in_secs + 3600) == true
    big_div = 10**97

    if !urgent && importance == "I'll get fired if I don't do this"
      due_date_rating = due_date_rating + time_est_in_secs
      new_rank = ((((due_date_rating + 400)/2)**9.6)/big_div).real
    elsif !urgent && importance == "pretty important"
      due_date_rating = due_date_rating + time_est_in_secs
      new_rank = ((((due_date_rating + 358)/2)**9.7)/big_div).real
    elsif !urgent && importance == "important"
      due_date_rating = due_date_rating + time_est_in_secs
      new_rank = ((((due_date_rating + 319.25)/2)**9.8)/big_div).real
    elsif !urgent && importance == "of trivial importance"
      due_date_rating = due_date_rating + time_est_in_secs
      new_rank = ((((due_date_rating + 283.45)/2)**9.9)/big_div).real
    elsif !urgent && importance == "not important at all"
      due_date_rating = due_date_rating + time_est_in_secs
      new_rank = ((((due_date_rating + 283.39)/2)**9.9)/big_div).real
    else
        new_rank = ((((due_date_rating + 400)/2)**10)/big_div).real
    end
      new_rank = new_rank.round(2)
      update_attribute(:rank, new_rank)
  end

end
