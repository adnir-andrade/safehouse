class Survivors::UpdateForm
  include ActiveModel::Model

  ATTRIBUTES = [:name, :gender, :age, :is_alive] 
  attr_accessor *ATTRIBUTES, :survivor

  # validates :age, numericality: { greater_than_or_equal_to: 15, less_than_or_equal_to: 90 }

  validate :has_content?

  def update
    return false if invalid?

    update_survivor
  end

  private

  def update_survivor
    survivor.update(
      name: name
    )
  end

  def has_content?
    ATTRIBUTES.each do |attribute|
      value = send(attribute)
      if value
        return if !value.empty?

        errors.add(:base, "#{attribute} cannot be empty")
      end
    end
  end
end