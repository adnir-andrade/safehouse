require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  let(:survivor) { create(:survivor) }

  describe 'GET #index' do
    it 'returns all locations from a survivor' do
      create_list(:location, 5, survivor: survivor);

      get :index, params: { survivor_id: survivor.id }, format: :json

      responseJSON = JSON.parse(response.body, { symbolize_names: true })
      expectedJSON = Location.all.map { |e| 
        {
          id: e.id,
          latitude: sprintf('%.7f', e.latitude),
          longitude: sprintf('%.7f', e.longitude),
          survivor: { id: e.survivor.id, name: e.survivor.name },
          created_at: e.created_at.strftime('%Y-%m-%d %H:%M:%S'),
          updated_at: e.updated_at.strftime('%Y-%m-%d %H:%M:%S')
        }
      }

      validate_success(response, 200, 5)
      expect(responseJSON).to eq(expectedJSON)
    end
  end

  def validate_success(response, status, locations_in_db = 0)
    expect(response).to have_http_status(status)
    expect(Location.count).to eq(locations_in_db)
  end
end