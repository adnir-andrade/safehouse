class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.decimal :longitude
      t.decimal :latitude
      t.references :survivor, foreign_key: true

      t.timestamps
    end
  end
end
