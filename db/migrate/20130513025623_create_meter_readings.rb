class CreateMeterReadings < ActiveRecord::Migration
  def change
    create_table :meter_readings do |t|
      t.string :usage_number
      t.string :corrected_amt
      t.string :remote_id
      t.string :meter_reading
      t.string :leak_status
      t.datetime :read_date
      t.string :address
      t.string :ocr_street_addr
      t.string :receiver_id
      t.string :service_type
      t.string :equipment_class
      t.string :meter_size
      t.string :route_id
      t.string :large_amt

      t.timestamps
    end
  end
end
