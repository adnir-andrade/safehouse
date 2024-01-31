require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:item) { attributes_for(:item) }
  let(:standard_item) { create(:item) }

  describe 'GET #index' do
    it 'returns all items' do
      create_list(:item, 10)

      get :index, format: :json

      responseJSON = JSON.parse(response.body, { symbolize_names: true})
      expectedJSON = Item.all.map { |item|
        formatJSON(item)
      }

      validate_success(response, 200, 10)
      expect(responseJSON).to eq(expectedJSON)
    end

    it 'returns a single item' do
      item = create(:item)

      get :show, params: { id: item.id }

      responseJSON = JSON.parse(response.body, { symbolize_names: true})
      expectedJSON = formatJSON(item)

      validate_success(response, 200, 1)
      expect(responseJSON).to eq(expectedJSON)
    end
  end

  describe 'POST #create' do
    context 'using valid attributes' do
      it 'creates a new item' do
        post :create, params: { item: item }

        validate_success(response, 201, 1)
      end

      context 'for item' do
        it 'creates an item with min valid value' do
          post :create, params: { item: item.merge(value: 0.01) }

          validate_success(response, 201, 1)
        end
      end

      context 'for description' do
        it 'creates an item without description' do
          post :create, params: { item: item.merge(description: nil) }

          validate_success(response, 201, 1)
        end
      end
    end

    context 'using invalid attributes' do
      context 'for name' do
        it "doesn't create an item when name is nil or empty" do
          post :create, params: { item: item.merge(name: nil) }

          validate_success(response, 422)
        end
      end

      context 'for value' do
        it "doesn't create an item when value is nil or empty" do
          post :create, params: { item: item.merge(value: nil) }

          validate_success(response, 422)
        end

        it "doesn't create an item when value is below min" do
          post :create, params: { item: item.merge(value: 0) }

          validate_success(response, 422)
        end
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates item with valid name' do
        put :update, params: { id: standard_item.id, item: { name: 'Bazooka' } }

        validate_success(response, 200, 1)
        expect(standard_item.reload.name).to eq('Bazooka')
      end

      it 'updates item with valid value' do
        put :update, params: { id: standard_item.id, item: { value: 77.98 } }

        validate_success(response, 200, 1)
        expect(standard_item.reload.value).to eq(77)
      end

      it "updates item's description" do
        put :update, params: { id: standard_item.id, item: { description: "That's probably gonna hurt if you point to the wrong direction"} }

        validate_success(response, 200, 1)
        expect(standard_item.reload.description).to eq("That's probably gonna hurt if you point to the wrong direction")
      end
    end

    context 'with invalid params' do
      it "doesn't update item when name is empty or nil" do
        original_name = standard_item.name
        put :update, params: { id: standard_item.id, item: { name: nil } }

        validate_success(response, 422, 1)
        expect(standard_item.reload.name).to eq(original_name)
      end

      context 'for value' do
        it "doesn't update item when value is empty or nil" do
          original_value = standard_item.value
          put :update, params: { id: standard_item.id, item: { value: nil } }

          validate_success(response, 422, 1)
          expect(standard_item.reload.value).to eq(original_value)
        end

        it "doesn't update item when value is below minimum" do
          original_value = standard_item.value
          put :update, params: { id: standard_item.id, item: { value: 0 } }
  
          validate_success(response, 422, 1)
          expect(standard_item.reload.value).to eq(original_value)
        end
      end
    end
  end

  def validate_success(response, status, items_in_db = 0)
    expect(response).to have_http_status(status)
    expect(Item.count).to eq(items_in_db)
  end

  def formatJSON(item)
    return formattedJson = { 
      id: item.id, 
      name: item.name, 
      value: item.value, 
      description: item.description
     }
  end
end