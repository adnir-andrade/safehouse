class RemoveIsArchivedFromSurvivors < ActiveRecord::Migration[7.1]
  def change
    remove_column :survivors, :is_archived, :boolean
  end
end
