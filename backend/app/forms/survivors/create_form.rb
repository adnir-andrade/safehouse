class Survivors::CreateForm
  include ActiveModel::Model

  attr_accessor :name, :gender, :age, :latitude, :longitude

  validates :name, presence: true
  validates :age, presence: true
  validates :gender, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  def create
    # pry.binding
    return nil if invalid?

    create_survivor
  end

  private
  def create_survivor
    survivor = Survivor.new(name: name, gender: gender, age: age, is_alive: true)
    survivor.save

    if survivor.persisted?
      locations_params =     {
        longitude: longitude,
        latitude: latitude
      }

      location = survivor.location.build(location_params)
      location.save

      survivor.update(location_id: location.id)
      survivor
    else
      error.merge!(survivor.errors)
      nil
    end
  end
end