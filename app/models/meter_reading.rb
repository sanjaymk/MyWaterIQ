class MeterReading < ActiveRecord::Base
  attr_accessible :address, :corrected_amt, :equipment_class, :large_amt, :leak_status, :meter_reading, :meter_size, :ocr_street_addr, :read_date, :receiver_id, :remote_id, :route_id, :service_type, :usage_number
end
