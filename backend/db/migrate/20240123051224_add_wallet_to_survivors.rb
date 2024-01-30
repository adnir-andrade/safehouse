class AddWalletToSurvivors < ActiveRecord::Migration[7.1]
  def change
    add_column :survivors, :wallet, :integer, default: 0
  end
end
