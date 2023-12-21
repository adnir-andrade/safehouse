require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
  let(:survivor) { attributes_for(:survivor) }
  let(:location) { attributes_for(:location) }
  let(:longitude) { location[:longitude] }
  let(:latitude) { location[:latitude] }
  let(:standard_survivor) { create(:survivor) }

  describe 'GET #index' do
    it 'returns all survivors' do
      create_list(:survivor, 10)

      get :index, format: :json

      validate_success(response, 200, 10)
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

        validate_success(response, 201, 1)
      end

      context "for age" do
        it "creates a survivor with minimum valid age" do
          post :create, params: { survivor: survivor.merge(age: 15), longitude: longitude, latitude: latitude }
  
          validate_success(response, 201, 1)
        end
  
        it "creates a survivor with maximum valid age" do
          post :create, params: { survivor: survivor.merge(age: 90), longitude: longitude, latitude: latitude }
  
          validate_success(response, 201, 1)
        end
      end

      context "for location" do
        it "creates a survivor with minimum allowed latitude" do
          post :create, params: { survivor: survivor, longitude: longitude, latitude: -90}

          validate_success(response, 201, 1)
        end

        it "creates a survivor with maximum allowed latitude" do
          post :create, params: { survivor: survivor, longitude: longitude, latitude: 90}

          validate_success(response, 201, 1)
        end

        it "creates a survivor with minimum allowed longitude" do
          post :create, params: { survivor: survivor, longitude: -180, latitude: latitude}

          validate_success(response, 201, 1)
        end

        it "creates a survivor with maximum allowed longitude" do
          post :create, params: { survivor: survivor, longitude: 180, latitude: latitude}

          validate_success(response, 201, 1)
        end
      end
    end

    context "using invalid attributes" do
      context "for name" do
        it "without a name" do
          post :create, params: { survivor: survivor.merge(name: nil), longitude: longitude, latitude: latitude }
  
          validate_success(response, 422)
        end
      end

      context "for age" do
        it "without a value" do
          post :create, params: { survivor: survivor.merge(age: nil), longitude: longitude, latitude: latitude }
  
          validate_success(response, 422)
        end
  
        it "when value is below minimum" do
          post :create, params: { survivor: survivor.merge(age: 14), longitude: longitude, latitude: latitude }
  
          validate_success(response, 422)
        end

        it "when value is above maximum" do
          post :create, params: { survivor: survivor.merge(age:91), longitude: longitude, latitude: latitude }

          validate_success(response, 422)
        end
      end

      context "for location" do
        it "when latitude is below minimum" do
          post :create, params: { survivor: survivor, longitude: longitude, latitude: -91 }

          validate_success(response, 422)
        end

        it "when latitude is above maximum" do
          post :create, params: { survivor: survivor, longitude: longitude, latitude: 91 }

          validate_success(response, 422)
        end

        it "when longitude is below minimum" do
          post :create, params: { survivor: survivor, longitude: -181, latitude: latitude }

          validate_success(response, 422)
        end

        it "when longitude is above maximum" do
          post :create, params: { survivor: survivor, longitude: 181, latitude: latitude }

          validate_success(response, 422)
        end
      end
    end
  end

  describe 'PUT #update' do
    context "with valid params" do
      it "update survivor with valid name" do
        put :update, params: { id: standard_survivor.id, survivor: { name: "Kenny"} }

        validate_success(response, 200, 1)
        expect(standard_survivor.reload.name).to eq("Kenny")
      end

      it "update survivor with valid age" do
        put :update, params: { id: standard_survivor.id, survivor: { age: 31} }

        validate_success(response, 200, 1)
        expect(standard_survivor.reload.age).to eq(31)
      end

      it "update survivor with valid gender (oh god I will be cancelled)" do
        #TODO: Later on, refactor gender to enum and make sure to update this test
        put :update, params: { id: standard_survivor.id, survivor: { gender: "Something"} }
      
        validate_success(response, 200, 1)
        expect(standard_survivor.reload.gender).to eq("Something")
      end

      it "update survivor with valid is_alive value" do
        put :update, params: { id: standard_survivor.id, survivor: { is_alive: false } }

        validate_success(response, 200, 1)
        expect(standard_survivor.reload.is_alive).to eq(false)
      end
    end

    context "with invalid params" do
      it "won't update when name is nil or empty" do
        original_name = standard_survivor.reload.name
        put :update, params: { id: standard_survivor.id, survivor: { name: nil }}

        validate_success(response, 422, 1)
        expect(standard_survivor.reload.name).to eq(original_name)
      end

      it "won't update when age is nil or empty" do
        original_age = standard_survivor.reload.age
        put :update, params: { id: standard_survivor.id, survivor: { age: nil} }

        validate_success(response, 422, 1)
        expect(standard_survivor.reload.age).to eq(original_age)
      end

      it "won't update when age when out of range (min value)" do
        original_age = standard_survivor.reload.age
        put :update, params: { id: standard_survivor.id, survivor: { age: 14}}

        validate_success(response, 422, 1)
        expect(standard_survivor.reload.age).to eq(original_age)
      end

      it "won't update when age when out of range (max value)" do
        original_age = standard_survivor.reload.age
        put :update, params: { id: standard_survivor.id, survivor: { age: 91}}

        validate_success(response, 422, 1)
        expect(standard_survivor.reload.age).to eq(original_age)
      end

      it "won't update when gender is nil or empty" do
        original_gender = standard_survivor.gender
        put :update, params: { id: standard_survivor.id, survivor: { gender: nil} }

        validate_success(response, 422, 1)
        expect(standard_survivor.reload.gender).to eq(original_gender)
      end
    end
  end

  def validate_success(response, status, survivors_in_db = 0)
    expect(response).to have_http_status(status)
    expect(Survivor.count).to eq(survivors_in_db)
  end
end