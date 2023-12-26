class Locations::UpdateForm
  include ActiveModel::Model

  ATTRIBUTES = [:latitude, :longitude]
  VALUES_TO_UPDATE = {}
  attr_accessor *ATTRIBUTES, :location

  validate :has_content?
  validate :latitude_within_range?
  validate :longitude_within_range?

  def update
    return false if invalid?

    update_location
  end

  private

  def update_location
    location.update(VALUES_TO_UPDATE)
  end

  def has_content?
    ATTRIBUTES.each do |attribute|
      value = send(attribute)
      if value
        if !value.empty?
          VALUES_TO_UPDATE[attribute] = value;
          return
        end

        errors.add(:base, "#{attribute} cannot be empty")
      end
    end
  end

  def latitude_within_range?
    if VALUES_TO_UPDATE[:latitude]
      latitude = VALUES_TO_UPDATE[:latitude].to_f
      return if latitude >= -90 && latitude <= 90

      errors.add(:base, "Latitude must be a value between -90 and 90!")
    end
  end

  def longitude_within_range?
    if VALUES_TO_UPDATE[:longitude]
      longitude = VALUES_TO_UPDATE[:longitude].to_f
      return if longitude >= -180 && longitude <= 180

      errors.add(:base, "Longitude must be a value between -180 and 180!")
    end
  end
end