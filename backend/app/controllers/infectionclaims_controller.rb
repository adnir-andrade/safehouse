class InfectionclaimsController < ApplicationController
  before_action :set_claim, only: %i[show update]

  def index
    @claims = InfectionClaim.all

    render json: @claims
  end

  def show
    render json: @claim
  end

  def new
    @claim = InfectionClaim.new
  end

  def create
    form = Infectionclaims::CreateForm.new(claim_params)

    if form.create
      render json: form, status: :created, location: @survivor
    else
      render json: { error: 'There was an error trying to CREATE an claim', details: form.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @claim.update
      render json: @claim
    else
      render json: { error: "Error trying to update claim", details: @claim.errors, params: claim_params }, status: :unprocessable_entity
    end
  end

  private
  
  def set_claim
    @claim = InfectionClaim.find(params[:id])
  end

  def claim_params
    params.require(:infectionclaim).permit(:id, :whistleblower, :infected_survivor)
  end
end