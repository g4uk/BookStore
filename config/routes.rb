Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  scope '(:locale)', locale: /en/ do
    ActiveAdmin.routes(self)
    devise_for :admin_users, { class_name: 'User', skip: :omniauth_callbacks }.merge(ActiveAdmin::Devise.config)
    devise_for :users, skip: :omniauth_callbacks, controllers: { registrations: 'users/registrations',
                                      sessions: 'users/sessions',
                                      passwords: 'users/passwords',
                                      omniauth_callbacks: 'users/omniauth_callbacks' }
    root to: 'pages#home'
    get 'pages/home', to: 'pages#home', as: :home
    get 'order_items/new/:book_id', to: 'order_items#create', as: :create_order_item
    get 'users/edit/:id', to: 'users#edit', as: :settings
    resources :orders, only: %i[index show create]
    resources :comments, only: :create
    resources :books, only: %i[index show]
    resources :order_items, only: %i[create destroy] do
      member do
        put :decrement
        put :increment
      end
    end
    resources :carts, only: %i[show update]
    resources :checkouts, only: %i[index show update]
    resources :users, only: %i[edit update destroy] do
      collection do
        patch :update_billing_address
        patch :update_shipping_address
        patch :update_password
        put :quick_signup
        get :login
        get :signup
        get :forgot_password
        get :change_password
        get :checkout_login
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
