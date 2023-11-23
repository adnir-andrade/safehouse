class AddReferencesToSurvivors < ActiveRecord::Migration[7.1]
  def change
    add_reference :survivors, :inventory, foreign_key: true
    add_reference :survivors, :location, foreign_key: true
  end
end
