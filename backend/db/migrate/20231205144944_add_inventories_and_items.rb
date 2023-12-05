class AddInventoriesAndItems < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories_items do |t|  
      t.belongs_to :item, index: true 
      t.belongs_to :inventory, index: true
    end
  end
end