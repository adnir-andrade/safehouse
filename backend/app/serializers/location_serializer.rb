class LocationSerializer < ActiveModel::Serializer

  attributes :id, :longitude, :latitude, :created_at, :updated_at

  belongs_to :survivor_model, serializer: SurvivorSerializer

  def longitude
    sprintf('%.7f', object.longitude)
  end

  def latitude
    sprintf('%.7f', object.latitude)
  end

  def created_at
    object.created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
  
  def updated_at
    object.updated_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end