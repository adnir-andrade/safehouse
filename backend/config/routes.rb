Rails.application.routes.draw do
  resources :survivors do
    put '/archive', to: 'survivors#archive', as: 'archive'
    resources :locations
  end

  resources :items

  resources :inventories, only: [:show, :update] do
    post '/add-item', on: :member, to: 'inventories#add_item', as: 'add-item'
  end
  

  resources :inventoriesitem

  resourealth#show", as: :rails_health_check
end
