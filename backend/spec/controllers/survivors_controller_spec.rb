require 'rails_helper'

RSpec.describe SurvivorsController, type: :controller do
  describe 'GET #index' do
    it 'returns all survivors' do
      create_survivors

      get :index, format: :json

      # expect(response).to have_http_status(200)
      # expect(JSON.parse(response.body))
    end
  end
end