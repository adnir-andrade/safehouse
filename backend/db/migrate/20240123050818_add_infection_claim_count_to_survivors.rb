class AddInfectionClaimCountToSurvivors < ActiveRecord::Migration[7.1]
  def change
    add_column :survivors, :infection_claim_count, :integer, default: 0
  end
end
