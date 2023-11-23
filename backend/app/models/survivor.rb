class Survivor < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_one :inventory, dependent: :destroy

  accepts_nested_attributes_for :locations
end
