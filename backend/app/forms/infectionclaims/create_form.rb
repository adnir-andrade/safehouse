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
    # TODO: Maybe check here if one of the survivors is dead already
    return false if invalid?

    create_claim
  end

  private

  def create_claim
    # TODO: Not working properly - ID Is auto-incrementing even when there is already an existing entry
    Survivor.transaction do
      claim = InfectionClaim.new(
        whistleblower: whistleblower, 
        infected_survivor: infected_survivor
        )
  
      if claim.save!
        check_survivor_claims
        return true
      else
        errors.merge!(claim.errors)
        return false
      end
    end
  end

  def check_survivor_claims
    infected_survivor.increment!(:infection_claim_count)
    if infected_survivor.infection_claim_count >= 5
      infected_survivor.update!(is_alive: false)
    end
  end
end