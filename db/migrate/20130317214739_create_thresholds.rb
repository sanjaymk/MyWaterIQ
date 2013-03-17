class CreateThresholds < ActiveRecord::Migration
  def change
    create_table :thresholds do |t|
      t.string :customer_id
      t.integer :threshold_value
      t.datetime :start_date
      t.datetime :end_date
      t.string :active

      t.timestamps
    end
  end
end
