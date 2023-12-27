class ItemsController < ApplicationController
  before_action :set_item, only: %i[show update]

  def index
    @items = Item.all

    render json: @items
  end

  def new
    @item = Item.new
  end

  def create
    form = Items::CreateForm.new(item_params)

    if form.create
      render json: form, status: :created, location: @survivor
    else
      render json: { error: 'There was an error trying to CREATE an item', details: form.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: @item
  end

  def update
    form = Items::UpdateForm.new(item_params.merge(item: @item))

    if form.update
      render json: form
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :value, :description)
  end

end
