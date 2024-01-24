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
    # TODO: Not working properly - ID Is auto-incrementing even when there is already an existing entry
    # Check with Ana - If there is no viable solution, just take the transaction away, I guess
    Survivor.transaction do
      claim = InfectionClaim.new(
        whistleblower: whistleblower,
        infected_survivor: infected_survivor,
      )

      if claim.save!
        update_survivor_status
        return true
      else
        errors.merge!(claim.errors)
        return false
      end
    end
  end

  def whistleblower_alive?
    return if @whistleblower.is_alive

    errors.add(:whistleblower, 'Whistleblower is infected or dead. Dead people have no opinion to give')
  end

  def update_survivor_status
    infected_survivor.increment!(:infection_claim_count)
    if infected_survivor.infection_claim_count >= 5
      infected_survivor.update!(is_alive: false)
    end
  end

  def unique_claim?
    claim_exists = InfectionClaim.exists?(whistleblower: whistleblower, infected_survivor: infected_survivor)
    return unless claim_exists

    errors.add(:claim, 'There is already a claim registered by this whistleblower against this survivor')
  end
end
