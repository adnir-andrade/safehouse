Rails.application.routes.draw do
  resources :survivors do
    put '/archive', to: 'survivors#archive', as: 'archive'
    resources :locations
  end

  resources :items

  get "up" => "rails/health#show", as: :rails_health_check
end
