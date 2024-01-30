Rails.application.routes.draw do
  resources :survivors do
    resources :locations
  end

  resources :infectionclaims

  resources :items

  resources :inventories, only: [:show, :update]
  
  resources :inventoriesitem, only: [:index, :show, :update] do
    collection do
      post '/add-item', to: 'inventoriesitem#add_item', as: 'add-item'

      get '/inventory/:inventory_id', to: 'inventoriesitem#inventory_index', as: 'inventory-index'

      put '/trade', to: 'inventoriesitem#trade', as: 'trade'
    end
    
    put '/remove-quantity', on: :member, to: 'inventoriesitem#remove_quantity', as: 'remove-quantity'
  end

  get '/reports/survivors/pdf/(:option)', to: 'survivors_report#survivors_report', defaults: { format: :pdf }
  get '/reports/items/pdf/(:option)', to: 'items_report#items_report', defaults: { format: :pdf }
  get '/reports/inventoriesitem/pdf/(:option)', to: 'inventoriesitem_report#inventoriesitem_report', defaults: { format: :pdf }
  get '/reports/statistics/pdf/survivors-status', to: 'survivors_report#survivors_status', defaults: { format: :pdf }
end
