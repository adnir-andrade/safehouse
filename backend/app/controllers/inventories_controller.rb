class InventoriesController < ApplicationController
  before_action :set_inventory, only: %i[show update add_item]

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

  def add_item
    # binding.pry
    form = Inventories::CreateForm.new(inventory_params)

    if form.add_item
      render json: form, status: :created, location: @inventory
    else
      render json: { error: 'There was an error trying to ADD AN ITEM to this inventory', details: form.errors }, status: :unprocessable_entity
    end
  end

  private
  
  def set_inventory
    # binding.pry
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.permit(:id, :item_id, :quantity)
  end

end