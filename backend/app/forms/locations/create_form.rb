class Locations::CreateForm
  include ActiveModel::Model

  attr_accessor :latitude, :longitude, :survivor

  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :survivor, presence: true

  validate :valid_location?

  def create
    return false if invalid?

    create_location
  end

  private

  def create_location
    location = survivor.locations.build(latitude: latitude, longitude: longitude)
    location.save
    
    if location.persisted?
      return true
    else
      errors.merge!(location.errors)
      return false
    end
  end

  def valid_location?
    latitude_range = (-90.0..90.0)
    longitude_range = (-180.0..180.0)

    return if (latitude_range.cover?(latitude.to_f) && longitude_range.cover?(longitude.to_f))

    errors.add(:base, 'Coordinate is out of bound')
  end
end