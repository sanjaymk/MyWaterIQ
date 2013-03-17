class Threshold < ActiveRecord::Base
  attr_accessible :active, :customer_id, :end_date, :start_date, :threshold_value
end
