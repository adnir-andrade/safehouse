class Survivors::CreateForm
  include ActiveModel::Model

  attr_accessor :name, :gender, :age, :longitude, :latitude

  validates :name, presence: true
  validates :age, presence: true
  validates :gender, presence: true
  validates :longitude, presence: true
  validates :latitude, presence: true

  def create
    return nil if invalid?

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
      nil
    end

    survivor
  end

end