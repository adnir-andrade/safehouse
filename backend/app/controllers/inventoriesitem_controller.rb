class InventoriesitemController < ApplicationController
  before_action :set_inventoryitem, only: %i[show update destroy remove_quantity]

  def index
    @inventoriesitem = InventoriesItem.all
    # TODO: Index should show all items from ID inventory. Or make another call to group by id_inventory

    render json: @inventoriesitem, adapter: :json
  end

  def show
    render json: @inventoryitem
  end

  def update
    if @inventory.update(inventoryitem_params)
      render json: @inventoryitem_params
    else
      render json: @inventoryitem.errors, status: :unprocessable_entity
    end
  end

  def destroy
    render json: @inventoryitem.destroy
  end

  def add_item
    form = Inventoriesitem::ItemManagementForm.new(inventoryitem_params)

    if form.add_quantity
      render json: form, status: :created
    else
      render json: { error: 'There was an error trying to ADD AN ITEM to this inventory', details: form.errors }, status: :unprocessable_entity
    end
  end

  def remove_quantity
    form = Inventoriesitem::ItemManagementForm.new(inventoryitem_params.merge(inventoryitem: @inventoryitem))

    if form.remove_quantity
      render json: form, status: :created
    else
      render json: { error: 'Error trying to remove quantity', details: form.errors }, status: :unprocessable_entity
    end
  end

  private

  def set_inventoryitem
    @inventoryitem = InventoriesItem.find(params[:id])
  end

  def inventoryitem_params
    params.require(:inventoriesitem).permit(:inventory_id, :item_id, :quantity)
  end
end