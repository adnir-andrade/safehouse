class Survivors::UpdateForm
  include ActiveModel::Model

  ATTRIBUTES = [:name, :gender, :age, :is_alive]
  VALUES_TO_UPDATE = {}
  attr_accessor *ATTRIBUTES, :survivor

  # validates :age, numericality: { greater_than_or_equal_to: 15, less_than_or_equal_to: 90 }

  validate :has_content?

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
end