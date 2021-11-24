class CreateScreenings < ActiveRecord::Migration[6.1]
  def change
    create_table :screenings do |t|
      t.integer :room
      t.date :date
      t.integer :time
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
