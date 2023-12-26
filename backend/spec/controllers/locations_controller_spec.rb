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

    context "using invalid attributes" do
      it "doesn't create a location without a survivor ID" do
        expect {
          post :create, params: { location: location, survivor_id: nil }
        }.to raise_error(ActionController::UrlGenerationError)
      end

      context "for latitude" do
        it "doesn't create a location when latitude is below minimum" do
          post :create, params: { location: location.merge(latitude: -90.1), survivor_id: survivor.id }

          validate_success(response, 422)
        end

        it "doesn't create a location when latitude is above maximum" do
          post :create, params: { location: location.merge(latitude: 90.1), survivor_id: survivor.id }

          validate_success(response, 422)
        end

        it "doesn't create a location when latitude is nil" do
          post :create, params: { location: location.merge(latitude: nil), survivor_id: survivor.id }

          validate_success(response, 422)
        end

        it "doesn't create a location when longitude is below minimum" do
          post :create, params: { location: location.merge(longitude: -180.1), survivor_id: survivor.id }

          validate_success(response, 422)
        end

        it "doesn't create a location when longitude is above maximum" do
          post :create, params: { location: location.merge(latitude: 180.1), survivor_id: survivor.id }

          validate_success(response, 422)
        end

        it "doesn't create a location when longitude is nil" do
          post :create, params: { location: location.merge(longitude: nil), survivor_id: survivor.id }

          validate_success(response, 422)
        end
      end
    end
  end

  describe 'PUT #update' do
    context "with valid params" do
      it "updates location with valid latitude" do
        put :update, params: { id: standard_location.id, survivor_id: standard_location.survivor_id, location: { latitude: 54.2321 } }

        validate_success(response, 200, 1)
        expect(standard_location.reload.latitude).to eq(54.2321)
      end

      it "updates location with valid longitude" do
        put :update, params: { id: standard_location.id, survivor_id: standard_location.survivor_id, location: { longitude: 174.12345 } }

        validate_success(response, 200, 1)
        expect(standard_location.reload.longitude).to eq(174.12345)
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