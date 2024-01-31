class CreateSurvivors < ActiveRecord::Migration[7.1]
  def change
    create_table :survivors do |t|
      t.string :name
      t.string "gender"
      t.integer :age
      t.boolean :is_alive
 
      t.timestamps
    end
  end
end
