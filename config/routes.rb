Rails.application.routes.draw do
  scope '(:locale)', locale: /en/ do
    ActiveAdmin.routes(self)
    devise_for :admin_users, { class_name: 'User' }.merge(ActiveAdmin::Devise.config)
    devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }
    root to: 'homes#index'
    get 'checkout/address'
    get 'checkout/delivery'
    get 'checkout/payment'
    get 'checkout/confirm'
    get 'homes/index', to: 'homes#index', as: :home
    get 'order_items/new/:book_id', to: 'order_items#create', as: :create_order_item
    get 'users/signup_customer', to: 'users#signup_customer', as: :signup_customer
    get 'users/edit/:id', to: 'users#edit', as: :settings
    resources :orders
    resources :comments
    resources :categories
    resources :authors
    resources :books, only: %i[index show]
    resources :order_items, only: %i[create update destroy]
    resources :carts, only: %i[show update destroy]
    resources :checkouts, only: %i[show update]
    resources :users, only: %i[edit update] do
      collection do
        patch :update_billing_address
        patch :update_shipping_address
        patch :update_password
        get :login_customer
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
