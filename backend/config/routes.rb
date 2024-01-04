Rails.application.routes.draw do
  resources :survivors do
    put '/archive', to: 'survivors#archive', as: 'archive'
    resources :locations
  end

  resources :items

  resources :inventories, only: [:show, :update]
  
  resources :inventoriesitem, only: [:index, :show, :update] do
    collection do
      post '/add-item', to: 'inventoriesitem#add_item', as: 'add-item'

      get '/inventory/:inventory_id', to: 'inventoriesitem#inventory_index', as: 'inventory-index'
    end
    
    put '/remove-quantity', on: :member, to: 'inventoriesitem#remove_quantity', as: 'remove-quantity'
  end
end
