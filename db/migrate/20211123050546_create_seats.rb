class CreateSeats < ActiveRecord::Migration[6.1]
  def change
    create_table :seats do |t|
      t.integer :col
      t.string :row
      t.references :screening, null: false, foreign_key: true

      t.timestamps
    end
  end
end
