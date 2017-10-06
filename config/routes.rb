Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/dashboard')

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :products, only: [:index, :create, :update]
  get '/products/import', to: 'products#import_index', as: 'import_index'
  put '/products/:id/import', to: 'products#import', as: 'product_import'
  get '/products/search', to: 'products#search'

  resources :orders
  resources :aliexpress_orders

  get '/dashboard', to: 'dashboard#index'
  get '/dashboard/json', to: 'dashboard#json'

  namespace :shopify do
    post '/orders/create', to: '/shopify_webhooks#orders_create'
    post '/orders/paid', to: '/shopify_webhooks#orders_paid'
    post '/products/update', to: '/shopify_webhooks#products_update'
  end
end
