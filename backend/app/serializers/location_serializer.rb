class LocationSerializer < ActiveModel::Serializer

  #TODO: In the future, maybe it would be a good idea to NOT show the survivor's info - It will probably be more efficient.
  attributes :id, :longitude, :latitude, :created_at, :updated_at, :survivor

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

  def survivor
    { id: object.survivor.id, name: object.survivor.name }
  end
end