class Infectionclaims::CreateForm
  include ActiveModel::Model

  attr_accessor :whistleblower, :infected_survivor

  validates :whistleblower, presence: true
  validates :infected_survivor, presence: true
  validate :whistleblower_alive?
  validate :unique_claim?

  def whistleblower=(id)
    @whistleblower = Survivor.find(id)
  end

  def infected_survivor=(id)
    @infected_survivor = Survivor.find(id)
  end

  def create
    return false if invalid?

    process_claim
  end

  private

  def process_claim
    claim = InfectionClaim.new(
      whistleblower: whistleblower,
      infected_survivor: infected_survivor,
    )

    if claim.save!
      infected_survivor.increase_infected_count
      return true
    else
      errors.merge!(claim.errors)
      return false
    end
  end

  def whistleblower_alive?
    return if @whistleblower.is_alive

    errors.add(:whistleblower, "Whistleblower is infected or dead. Dead people have no opinion to give")
  end

  def unique_claim?
    claim_exists = InfectionClaim.exists?(whistleblower: whistleblower, infected_survivor: infected_survivor)
    return unless claim_exists

    errors.add(:claim, "There is already a claim registered by this whistleblower against this survivor")
  end
end
