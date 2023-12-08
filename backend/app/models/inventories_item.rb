class InventoriesItem < ApplicationRecord
  belongs_to :inventory
  belongs_to :item
end