class CreateTestTables < ActiveRecord::Migration
  def change
    create_table :test_tables do |t|
      t.string :meter_id
      t.string :read_date

      t.timestamps
    end
  end
end
