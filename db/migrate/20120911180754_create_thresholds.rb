class CreateThresholds < ActiveRecord::Migration
  def change
    create_table :thresholds do |t|
      t.string :threshold_type
      t.string :threshold_value
      t.date :threshold_effective_date
      t.date :threshold_end_date

      t.timestamps
    end
  end
end
