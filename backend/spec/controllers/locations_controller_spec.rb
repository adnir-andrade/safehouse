require 'rails_helper'

RSpec.describe LocationsController, type: :controller do
  let(:survivor) { create(:survivor) }
  let(:location) { attributes_for(:location) }

  describe 'GET #index' do
    it 'returns all locations from a survivor' do
      create_list(:location, 5, survivor: survivor);

      get :index, params: { survivor_id: survivor.id }, format: :json

      responseJSON = JSON.parse(response.body, { symbolize_names: true })
      expectedJSON = Location.all.map { |e| 
        formatJSON(e)
      }

      validate_success(response, 200, 5)
      expect(responseJSON).to eq(expectedJSON)
    end

    it 'returns a single location from a survivor' do
      location = create(:location, survivor: survivor)

      get :show, params: { survivor_id: survivor.id, id: location.id }, format: :json

      responseJSON = JSON.parse(response.body, { symbolize_names: true })
      expectedJSON = formatJSON(location)
      
      validate_success(response, 200, 1)
      expect(responseJSON).to eq(expectedJSON)
    end
  end

  describe 'POST #create' do
    context "using valid attributes" do
      it "creates a new location" do
        post :create, params: { location: location, survivor_id: survivor.id }

        validate_success(response, 201, 1)
      end

      context "for latitude" do
        it "creates a location with minimum valid latitude" do
          post :create, params: { location: location.merge(latitude: -90), survivor_id: survivor.id }

          validate_success(response, 201, 1)
        end
        
        it "creates a location with maximum valid latitude" do
          post :create, params: { location: location.merge(latitude: 90), survivor_id: survivor.id }

          validate_success(response, 201, 1)
        end
      end

      context "for longitude" do
        it "creates a location with minimum valid longitude" do
          post :create, params: { location: location.merge(longitude: -180), survivor_id: survivor.id }

          validate_success(response, 201, 1)
        end
        
        it "creates a location with maximum valid longitude" do
          post :create, params: { location: location.merge(longitude: 180), survivor_id: survivor.id }

          validate_success(response, 201, 1)
        end
      end
    end
    end
  end

  def validate_success(response, status, locations_in_db = 0)
    expect(response).to have_http_status(status)
    expect(Location.count).to eq(locations_in_db)
  end

  def formatJSON(location)
    return formattedJson = {
      id: location.id,
      latitude: sprintf('%.7f', location.latitude),
      longitude: sprintf('%.7f', location.longitude),
      survivor: { id: location.survivor.id, name: location.survivor.name },
      created_at: location.created_at.strftime('%Y-%m-%d %H:%M:%S'),
      updated_at: location.updated_at.strftime('%Y-%m-%d %H:%M:%S')
    }
  end
end