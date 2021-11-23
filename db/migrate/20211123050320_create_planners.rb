class CreatePlanners < ActiveRecord::Migration[6.1]
  def change
    create_table :planners do |t|
      t.integer :room
      t.date :start_date
      t.date :end_date
      t.integer :time
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
