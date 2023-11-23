class Item < ApplicationRecord
  has_many :items_inventories
  has_many :inventories, through: :items_inventories
end
