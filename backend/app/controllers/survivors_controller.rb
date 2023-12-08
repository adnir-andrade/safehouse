class SurvivorsController < ApplicationController
  before_action :set_survivor, only: %i[show update destroy archive]

  def index
    @survivors = Survivor.all

    render json: @survivors, adapter: :json
  end

  def new
    @survivor = Survivor.new
  end
  
  def create
    form = Survivors::CreateForm.new(survivor_params.merge(location_params))
    
    if form.create
      render json: form, status: :created, location: @survivor
    else
      render json: { error: 'There was an error trying to CREATE survivor', details: form.errors }, status: :unprocessable_entity
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
        render json: @survivor
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

  # Discover why survivor_params is not working as intended 

  def survivor_params
    permitted_params = base_survivor_attributes + [:longitude, :latitude]
    params.require(:survivor).permit(*permitted_params)
  end

  def location_params
    {
      longitude: params[:longitude],
      latitude: params[:latitude]
    }
  end
  
  def base_survivor_attributes
    [:name, :gender, :age]
  end

end