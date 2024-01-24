class Survivor < ApplicationRecord
  has_many :locations, dependent: :destroy
  has_one :inventory, dependent: :destroy

  has_many :accusations_made, class_name: 'InfectionClaim', foreign_key: 'whistleblower_id'
  has_many :accusations_received, class_name: 'InfectionClaim', foreign_key: 'infected_survivor_id'

  accepts_nested_attributes_for :locations

  def increase_infected_count
    increment!(:infection_claim_count)
    update(is_alive: false) if infection_claim_count >= 5 && is_alive
  end
end
