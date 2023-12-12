class Items::CreateForm
  include ActiveModel::Model

  attr_accessor :name, :value, :description

  validates :name, presence: true
  validates :value, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true

  def create
    return false if invalid?

    create_item
  end

  private

  def create_item   
    item = Item.new(name: name, value: value, description: description)

    if item.save
      return true
    else
      errors.merge!(item.errors)
      return false
    end
  end
end