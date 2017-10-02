Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products, only: [:index, :create, :update]
  get '/products/import', to: 'products#import_index', as: 'import_index'
  put '/products/:id/import', to: 'products#import', as: 'product_import'
  get '/products/search', to: 'products#search'

  resources :orders
  resources :aliexpress_orders

  get '/dashboard', to: 'dashboard#index'
end
