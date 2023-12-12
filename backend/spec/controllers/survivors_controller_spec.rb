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
    context "with valid attributes" do
      it "successfully creates a survivor" do
        post :create, params: { survivor: survivor, longitude: longitude, latitude: latitude }

        validade_successful_creation(response)
      end

      it "successfully creates a survivor with valid age" do
        post :create, params: { survivor: survivor.merge(age: 120), longitude: longitude, latitude: latitude }

        validade_successful_creation(response)
      end
    end

    context "with invalid attributes" do
      it "does not create a survivor without a name" do
        post :create, params: { survivor: survivor.merge(name: nil), longitude: longitude, latitude: latitude }

        validade_unsuccessful_creation(response)
      end

      it "does not create a survivor without a age" do
        post :create, params: { survivor: survivor.merge(age: nil), longitude: longitude, latitude: latitude }

        validade_unsuccessful_creation(response)
      end

      it "does not create a survivor with an invalid age" do
        post :create, params: { survivor: survivor.merge(age: 121), longitude: longitude, latitude: latitude }

        validade_unsuccessful_creation(response)
      end

      it "does not create a survivor with an invalid longitude" do
        post :create, params: { survivor: survivor, longitude: longitude, latitude: 91 }

        validade_unsuccessful_creation(response)
      end

      it "does not create a survivor with an invalid latitude" do
        post :create, params: { survivor: survivor, longitude: 181, latitude: latitude }

        validade_unsuccessful_creation(response)
      end
    end
  end

  def validade_successful_creation(response)
    expect(response).to have_http_status(201)
    expect(Survivor.count).to eq(1)
  end
  
  def validade_unsuccessful_creation(response)
    expect(response).to have_http_status(422)
    expect(Survivor.count).to eq(0)
  end
  
end