class SurvivorsController < ApplicationController
  before_action :set_survivor, only: %i[show update destroy archive]

  def index
    @survivors = Survivor.all
    survivor_complete = []
  
    @survivors.each do |survivor|
      unless survivor.is_archived?
        survivor_last_location = survivor.locations.last
    
        survivor_data = {
          id: survivor.id,
          name: survivor.name,
          age: survivor.age,
          gender: survivor.gender,
          is_alive: survivor.is_alive,
          location_id: survivor.location_id,
          longitude: survivor_last_location&.longitude,
          latitude: survivor_last_location&.latitude,
          inventory_id: survivor.inventory_id,
          created_at: survivor.created_at,
          updated_at: survivor.updated_at,
        }
    
        survivor_complete << survivor_data
      end
    end

    render json: survivor_complete
  end
  
  def create
    @survivor = Survivor.new(survivor_params)
    
    if @survivor.save
      location = @survivor.locations.build(location_params)
      location.save
      @survivor.update(location_id: location.id)

      render json: @survivor, status: :created, location: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @survivor
  end
  
  def update
    if @survivor.update(survivor_params)
      render json: @survivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end
  
  def archive
    if @survivor.update(is_archived: true)
        render json: @suvivor
    else
      render json: @survivor.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @survivor.destroy
  end

  private

  def set_survivor
    @survivor = Survivor.find(params[:id])
  end

  def survivor_params
    params.require(:survivor).permit(base_survivor_attributes, :longitude, :latitude)
  end
  
  def location_params
    {
      longitude: params[:longitude],
      latitude: params[:latitude]
    }
  end
  
  def base_survivor_attributes
    [:name, :gender, :age, :is_alive]
  end

end