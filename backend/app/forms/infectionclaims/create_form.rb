class Infectionclaims::CreateForm
  include ActiveModel::Model

  attr_accessor :whistleblower, :infected_survivor

  validates :whistleblower, presence: true
  validates :infected_survivor, presence: true

  def whistleblower=(id)
    @whistleblower = Survivor.find(id)
  end

  def infected_survivor=(id)
    @infected_survivor = Survivor.find(id)
  end

  def create
    return false if invalid?

    create_claim
  end

  private

  def create_claim
    Survivor.transaction do
      claim = InfectionClaim.new(
        whistleblower: whistleblower, 
        infected_survivor: infected_survivor
        )
  
      if claim.save!
        return true
      else
        errors.merge!(claim.errors)
        return false
      end
    end
  end
end