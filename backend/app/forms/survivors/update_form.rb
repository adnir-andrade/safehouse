class Survivors::UpdateForm
  include ActiveModel::Model

  ATTRIBUTES = [:name, :gender, :age, :is_alive]
  VALUES_TO_UPDATE = {}
  attr_accessor *ATTRIBUTES, :survivor

  validate :has_content?
  validate :age_within_range?

  def update
    return false if invalid?

    update_survivor
  end

  private

  def update_survivor
    survivor.update(VALUES_TO_UPDATE)
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

  def age_within_range?
    if VALUES_TO_UPDATE[:age]
      age = VALUES_TO_UPDATE[:age].to_i
      return if age >= 15 && age <=90

      errors.add(:base, "Age must be a value between 15 and 90!")
    end
  end
end