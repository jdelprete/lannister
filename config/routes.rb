Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products
  put '/products/:id/import', to: 'products#import', as: 'product_import'

  resources :orders
  resources :aliexpress_orders
end
