class Inventory < ApplicationRecord
  belongs_to :survivor
  has_many :inventories_items
  has_many :items, through: :inventories_items
end
