require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:item) { attributes_for(:item)}

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