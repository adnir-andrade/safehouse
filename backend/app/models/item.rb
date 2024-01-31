class Item < ApplicationRecord
  has_many :inventories_items
  has_many :inventories, through: :inventories_items
end
