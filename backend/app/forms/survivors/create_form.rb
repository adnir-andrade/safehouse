class Survivors::CreateForm
  include ActiveModel::Model

  attr_accessor :name, :gender, :age, :is_alive

  validates :name, presence: true
  validates :age, presence: true
  validates :gender, presence: true
  validates :is_alive, presence: true

  def create
    return nil if invalid?

    create_survivor
  end

  private
  def create_survivor
    survivor = Survivor.new(name: name, gender: gender, age: age, is_alive: is_alive)
    survivor.save
    survivor
  end

end