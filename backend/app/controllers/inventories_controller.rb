class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[show update]

  def show
    render json: @inventory
  end

  def update
    if @inventory.update
      render json: @inventory
    else
      render json: { error: "Error trying to update inventory", details: @inventory.errors, params: inventory_params }, status: :unprocessable_entity
    end
  end

  private
  
  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.permit(:id)
  end
end