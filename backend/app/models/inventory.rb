class Inventory < ApplicationRecord
  belongs_to :survivor
  # has_many :items_inventories
  # has_many :item, through: :items_inventories
end
