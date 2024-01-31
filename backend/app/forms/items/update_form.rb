class Items::UpdateForm
  include ActiveModel::Model

  ATTRIBUTES = [:name, :value, :description]
  VALUES_TO_UPDATE = {}
  attr_accessor *ATTRIBUTES, :item

  validate :has_content?
  validate :value_above_zero?

  def update
    return false if invalid?

    update_item
  end

  private

  def update_item
    item.update(VALUES_TO_UPDATE)
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

  def value_above_zero?
    if VALUES_TO_UPDATE[:value]
      value = VALUES_TO_UPDATE[:value].to_f
      return if value > 0

      errors.add(:base, "Value must be a positive number")
    end
  end
end