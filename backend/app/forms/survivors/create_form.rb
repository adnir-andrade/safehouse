class Survivors::CreateForm
  include ActiveModel::Model

  attr_accessor :name, :gender, :age

  validates :name, presence: true
  validates :age, presence: true
  validates :gender, presence: true

  def create
    return nil if invalid?

    create_survivor
  end

  private
  def create_survivor
    survivor = Survivor.new(name: name, gender: gender, age: age, is_alive: true)
    survivor.save
    survivor
  end

end