class InventoriesitemController < ApplicationController
  before_Action :set_inventoryitem, only %i[show update destroy]

  def index
    @inventoriesitem = Inventoriesitem.all
    # TODO: Index should show all items from ID inventory

    render json: @inventoriesitem, adapter: :json
  end

  def new
    @inventoryitem = Inventoriesitem.new
  end

  def create
    @inventoryitem = Inventoriesitem.new(inventoryitem_params)

    if @inventoryitem.save
      render json: @inventoryitem, status: :created
    else
      render json: { error: 'There was an error trying to CREATE item in inventory', details: @inventoriesitem.errors }, status: :unprocessable_entity
    end
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

  private

  def set_inventoryitem
    @inventoryitem = Inventoryitem.find(params[:id])
  end

  def inventoryitem_params
    paramas.require(:inventoryitem).permit(:quantity)
  end
