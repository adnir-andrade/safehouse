class LocationsController < ApplicationController
  before_action :get_survivor
  before_action :set_location, only: %i[show update destroy]

  def index
    @locations = @survivor.locations

    render json: @locations
  end

  def create
    form = Locations::CreateForm.new(location_params)

    if form.create
      render json: form, status: :created
    else
      render json: { error: "Error trying to Create a Location", details: form.errors, params: location_params }, status: :unprocessable_entity
    end
  end
  
  def show
    render json: @location
  end

  def update
    form = Locations::UpdateForm.new(location_params.merge(location: @location))

    if form.update
      render json: form
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @location.destroy
  end

  private

  def get_survivor
    @survivor = Survivor.find(params[:survivor_id])
  end

  def set_location
    @location = @survivor.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:latitude, :longitude).merge(survivor_id: params[:survivor_id])
  end
end
