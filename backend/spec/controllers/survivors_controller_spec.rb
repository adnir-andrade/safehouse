require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
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
        survivor = attributes_for(:survivor)
        location = attributes_for(:location)
        
        post :create, params: { survivor: survivor, longitude: location[:longitude], latitude: location[:latitude] }

        expect(response).to have_http_status(201)
        expect(Survivor.count).to eq(1)
      end

      it "successfully creates a survivor with valid age" do
        survivor = attributes_for(:survivor, age: 17)
        location = attributes_for(:location)

        post :create, params: { survivor: survivor, longitude: location[:longitude], latitude: location[:latitude] }

        expect(response).to have_http_status(201)
        expect(Survivor.count).to eq(1)
      end
    end

    context "with invalid attributes" do
      it "does not create a survivor without a name" do
        post :create, params: { survivor: attributes_for(:survivor, name: nil) }

        expect(response).to have_http_status(422)
        expect(Survivor.count).to eq(0)
      end

      it "does not create a survivor without age" do
        post :create, params: { survivor: attributes_for(:survivor, age: nil) }

        expect(response).to have_http_status(422)
        expect(Survivor.count).to eq(0)
      end

      it "does not create a survivor with an invalid age" do
        post :create, params: { survivor: attributes_for(:survivor, age: 777) }

        expect(response).to have_http_status(422)
        expect(Survivor.count).to eq(0)
      end
    end
  end
end
