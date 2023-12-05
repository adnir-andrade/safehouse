class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.integer :value
      t.string :description

      t.timestamps
    end
  end
end
