require 'rails_helper'

RSpec.describe InventoriesitemController, type: :controller do
  let(:inventory) { create(:inventory) }
  let(:item) { create(:item) }
  let(:inventoryitem) { attributes_for(:inventoryitem) }
  let(:standard_entry) { attributes_for(:inventoryitem, inventory_id: inventory.id, item_id: item.id) }

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

    it 'returns a single entry' do
      inventoryitem = create(:inventoryitem)

      get :show, params: { id: inventoryitem.id }

      responseJSON = JSON.parse(response.body, { symbolize_names: true })
      expectedJSON = formatJSON(inventoryitem)
    end

    it 'returns all entries related to a single inventory_id' do
      create_list(:inventoryitem, 10)

      get :inventory_index, params: { inventory_id: InventoriesItem.first.inventory_id }
      
      responseJSON = JSON.parse(response.body, { symbolize_names: true })

      selected_entries = InventoriesItem.all.select { |inventoryitem|
        inventoryitem.inventory_id == InventoriesItem.first.inventory_id
      }

      expectedJSON = selected_entries.map { |inventoryitem|
        formatJSON(inventoryitem)
      }

      validate_success(response, 200, 10)
      expect(responseJSON).to eq(expectedJSON)
    end
  end

  describe 'POST #add_item' do
    context 'using valid attributes' do
      it 'adds new entry to the inventory' do
        post :add_item, params: { inventoriesitem: standard_entry }

        validate_success(response, 201, 1)
      end

      it 'adds quantity to existing entry' do
        existing_entry = InventoriesItem.create(standard_entry)
        original_quantity = existing_entry.quantity
        
        post :add_item, params: { inventoriesitem: standard_entry }
        
        expect(existing_entry.reload.quantity).to eq(original_quantity * 2)        
        validate_success(response, 201, 1)
      end

      it 'creates a new entry with minimum quantity' do
        post :add_item, params: { inventoriesitem: standard_entry.merge(quantity: 1) }

        validate_success(response, 201, 1)
      end
    end

    context 'using invalid attributes' do
      it "doesn't create a new entry when quantity below minimum" do
        post :add_item, params: { inventoriesitem: standard_entry.merge(quantity: 0) }

        validate_success(response, 422)
      end

      it "doesn't create a new entry when quantity is nil or empty" do
        post :add_item, params: { inventoriesitem: standard_entry.merge(quantity: nil) }

        validate_success(response, 422)
      end
    end
  end

  describe 'PUT #remove_quantity' do
    context 'using valid attributes' do
      it 'removes quantity from an entry' do
        existing_entry = InventoriesItem.create(standard_entry.merge(quantity: 10))
        put :remove_quantity, params: { id: existing_entry.id, inventoriesitem: { quantity: 3 } }
        
        expect(existing_entry.reload.quantity).to eq(7)        
        validate_success(response, 200, 1)
      end
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