class SurvivorSerializer < ActiveModel::Serializer

  attributes :id, :name, :age, :gender, :is_alive, :infection_claim_count, :wallet, :location_id, :inventory_id, :created_at, :updated_at

  has_many :locations

  def created_at
    object.created_at.strftime('%Y-%m-%d')
  end
  
  def updated_at
    object.updated_at.strftime('%Y-%m-%d')
  end

  def is_alive
    if object.is_alive
      "Alive"
    else
      "Dead"
    end
  end

end