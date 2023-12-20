class Survivors::CreateForm
  include ActiveModel::Model

  attr_accessor :name, :gender, :age, :is_alive, :longitude, :latitude, :survivor

  validates :name, presence: true
  validates :age, presence: true, numericality: { greater_than_or_equal_to: 15, less_than_or_equal_to: 90 }
  validates :gender, presence: true
  validates :longitude, presence: true
  validates :latitude, presence: true

  validate :valid_location?

  def create
    return false if invalid?

    create_survivor
  end

  private

  def create_survivor   
    survivor = Survivor.new(name: name, gender: gender, age: age, is_alive: true)
    survivor.save

    if survivor.persisted?
      location = survivor.locations.build({longitude: longitude, latitude: latitude})
      location.save
      survivor.update(location_id: location.id)
    else
      errors.merge!(survivor.errors)
      return false
    end

    return true
  end

  def valid_location?
    latitude_range = (-90.0..90.0)
    longitude_range = (-180.0..180.0)

    return if (latitude_range.cover?(latitude.to_f) && longitude_range.cover?(longitude.to_f))

    errors.add(:base, 'Coordinate is out of bound')
  end

end