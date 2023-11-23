class AddIsArchivedToSurvivors < ActiveRecord::Migration[7.1]
  def change
    add_column :survivors, :is_archived, :boolean
  end
end
