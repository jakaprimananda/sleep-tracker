class CreateSleepRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :sleep_records do |t|
      t.references :user, null: false, foreign_key: true
      t.timestamp :clock_in, null: false
      t.timestamp :clock_out

      t.timestamps
    end
  end
end
