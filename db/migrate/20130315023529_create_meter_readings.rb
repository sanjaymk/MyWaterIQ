class CreateMeterReadings < ActiveRecord::Migration
  def change
    create_table :meter_readings do |t|
      t.string :meter_id
      t.datetime :read_date
      t.string :meter_reading
      t.integer :corrected_amt
      t.string :receiver_id
      t.string :customer
      t.string :customer_name
      t.string :location_id
      t.string :location
      t.string :service_address
      t.string :meter_number
      t.string :meter_size

      t.timestamps
    end
  end
end
