class Survivors::UpdateForm
  include ActiveModel::Model

  attr_accessor :name, :gender, :age, :is_alive, :survivor

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
    return if !name.empty?

    errors.add(:base, 'Name cannot be empty')
  end
end