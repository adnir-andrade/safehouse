require 'rails_helper'

RSpec.describe ItemsController, type: :controller do

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