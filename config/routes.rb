# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  scope '(:locale)', locale: /en/ do
    ActiveAdmin.routes(self)
    devise_for :admin_users, { class_name: 'User', skip: :omniauth_callbacks }.merge(ActiveAdmin::Devise.config)
    devise_for :users, skip: :omniauth_callbacks, controllers: { registrations: 'users/registrations',
                                                                 sessions: 'users/sessions',
                                                                 passwords: 'users/passwords',
                                                                 omniauth_callbacks: 'users/omniauth_callbacks' }
    root to: 'pages#home'
    resources :orders, only: %i[index show create]
    resources :books, shallow: true, only: %i[index show] do
      resources :comments, only: :create
      resources :order_items, only: %i[create destroy] do
        member do
          put :decrement
          put :increment
        end
      end
    end
    resources :carts, only: %i[show update]
    resources :checkouts, only: %i[index show update]
    resources :users, only: %i[edit update destroy] do
      collection do
        post :update_password
        get :login
        get :signup
        get :forgot_password
        get :change_password
      end
    end
    resources :quick_signups, only: %i[new create]
    resources :addresses, only: :create
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
