class Reading < ActiveRecord::Base
  attr_accessible :corrected_amt, :customer, :customer_name, :location_id, :location,:meter_id, :meter_number, :meter_reading, :meter_size, :read_date, :receiver_id, :service_address
end
