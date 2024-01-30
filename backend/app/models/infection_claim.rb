class InfectionClaim < ApplicationRecord
  belongs_to :whistleblower, class_name: 'Survivor'
  belongs_to :infected_survivor, class_name: 'Survivor'
end
