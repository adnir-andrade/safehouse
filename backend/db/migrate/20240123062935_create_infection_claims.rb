class CreateInfectionClaims < ActiveRecord::Migration[7.1]
  def change
    create_table :infection_claims do |t|
      t.references :whistleblower, null: false, foreign_key: { to_table: :survivors }
      t.references :infected_survivor, null: false, foreign_key: { to_table: :survivors }

      t.timestamps
    end

    add_index :infection_claims, [:whistleblower_id, :infected_survivor_id], unique: true
  end
end
