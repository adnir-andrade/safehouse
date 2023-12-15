require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
  let(:survivor) { attributes_for(:survivor) }
  let(:location) { attributes_for(:location) }
  let(:longitude) { location[:longitude] }
  let(:latitude) { location[:latitude] }

  describe 'GET #index' do
    it 'returns all survivors' do
      create_list(:survivor, 10)

      get :index, format: :json

      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body, {
        symbolize_names: true,
      })[:survivors]).to eq(
        Survivor.all.map { |e| { 
          id: e.id, 
          name: e.name, 
          gender: e.gender, 
          age: e.age, 
          is_alive: "Alive",
          locations: [], 
          created_at: e.created_at.strftime('%Y-%m-%d'),
          updated_at: e.updated_at.strftime('%Y-%m-%d'),
          inventory_id: e.inventory_id,
          location_id: e.location_id
         } }
      )
    end
  end

  describe 'POST #create' do
    context "using valid attributes" do
      it "creates a survivor" do
        post :create, params: { survivor: survivor, longitude: longitude, latitude: latitude }

        validate_successful_creation(response)
      end

      context "for age" do
        it "creates a survivor with minimum valid age" do
          post :create, params: { survivor: survivor.merge(age: 15), longitude: longitude, latitude: latitude }
  
          validate_successful_creation(response)
        end
  
        it "creates a survivor with maximum valid age" do
          post :create, params: { survivor: survivor.merge(age: 90), longitude: longitude, latitude: latitude }
  
          validate_successful_creation(response)
        end
      end

      context "for location" do
        it "creates a survivor with minimum allowed latitude" do
          post :create, params: { survivor: survivor, longitude: longitude, latitude: -90}

          validate_successful_creation(response)
        end

        it "creates a survivor with maximum allowed latitude" do
          post :create, params: { survivor: survivor, longitude: longitude, latitude: 90}

          validate_successful_creation(response)
        end

        it "creates a survivor with minimum allowed longitude" do
          post :create, params: { survivor: survivor, longitude: -180, latitude: latitude}

          validate_successful_creation(response)
        end

        it "creates a survivor with maximum allowed longitude" do
          post :create, params: { survivor: survivor, longitude: 180, latitude: latitude}

          validate_successful_creation(response)
        end
      end
    end

    context "using invalid attributes" do
      context "for name" do
        it "without a name" do
          post :create, params: { survivor: survivor.merge(name: nil), longitude: longitude, latitude: latitude }
  
          validate_unsuccessful_creation(response)
        end
      end

      context "for age" do
        it "without a value" do
          post :create, params: { survivor: survivor.merge(age: nil), longitude: longitude, latitude: latitude }
  
          validate_unsuccessful_creation(response)
        end
  
        it "when value is below minimum" do
          post :create, params: { survivor: survivor.merge(age: 14), longitude: longitude, latitude: latitude }
  
          validate_unsuccessful_creation(response)
        end

        it "when value is above maximum" do
          post :create, params: { survivor: survivor.merge(age:121), longitude: longitude, latitude: latitude }

          validate_unsuccessful_creation(response)
        end
      end

      context "for location" do
        it "when latitude is below minimum" do
          post :create, params: { survivor: survivor, longitude: longitude, latitude: -91 }

          validate_unsuccessful_creation(response)
        end

        it "when latitude is above maximum" do
          post :create, params: { survivor: survivor, longitude: longitude, latitude: 91 }

          validate_unsuccessful_creation(response)
        end

        it "when longitude is below minimum" do
          post :create, params: { survivor: survivor, longitude: -181, latitude: latitude }

          validate_unsuccessful_creation(response)
        end

        it "when longitude is above maximum" do
          post :create, params: { survivor: survivor, longitude: 181, latitude: latitude }

          validate_unsuccessful_creation(response)
        end
      end
    end
  end

  describe 'PUT #update' do
    # TODO: Implement this later
  end

  def validate_successful_creation(response)
    expect(response).to have_http_status(201)
    expect(Survivor.count).to eq(1)
  end
  
  def validate_unsuccessful_creation(response)
    expect(response).to have_http_status(422)
    expect(Survivor.count).to eq(0)
  end
  
end