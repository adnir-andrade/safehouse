require 'rails_helper'

RSpec.describe InventoriesitemController, type: :controller do
  let(:inventory) { create(:inventory) }
  let(:item) { create(:item) }

  describe 'GET #index' do
    it 'returns all records' do
      create_list(:inventoryitem, 10)

      get :index, format: :json

      responseJSON = JSON.parse(response.body, { symbolize_names: true })
      expectedJSON = InventoriesItem.all.map { |inventoryitem|
        formatJSON(inventoryitem)
      }

      validate_success(response, 200, 10)
      expect(responseJSON).to eq(expectedJSON)
    end  
  end

  def validate_success(response, status, db_entries = 0)
    expect(response).to have_http_status(status)
    expect(InventoriesItem.count).to eq(db_entries)
  end

  def formatJSON(e)
    return formattedJson = {
      id: e.id,
      item: {
        id: e.item.id,
        name: e.item.name,
        quantity: e.quantity
      },
      owner: {
        id: e.inventory.survivor.id,
        name: e.inventory.survivor.name,
        inventory_id: e.inventory_id
      }
     }
  end
end