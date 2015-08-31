Rails.application.routes.draw do

  root to: 'visitors#index'
  devise_for :users
  
  get 'users/list'
  get 'messages/list'

  namespace :api do
    match 'subscriptions/convert_currency', to: 'subscriptions#convert_currency', via: :post
    match 'subscriptions/create', to: 'subscriptions#create', via: :post
    resources :messages, :users, except: [:new, :edit]
  end

  # namespace path_helper hackery!
  get '/api/messages/:id', to: 'messages#show', as: :message
  get '/api/users/:id', to: 'users#show', as: :user

  get 'plans', to: 'subscriptions#plans', as: :plans
  get 'plan/:id/subscribe', to: 'subscriptions#new', as: :new_subscription
  get 'plan/:id/upgrade', to: 'subscriptions#upgrade', as: :upgrade_subscription
  get 'plan/:id/deactivate', to: 'subscriptions#deactivate', as: :deactivate_subscription
  get 'plan/:id/reactivate', to: 'subscriptions#reactivate', as: :reactivate_subscription
  get 'plan/:id/unsubscribe', to: 'subscriptions#destroy', as: :destroy_subscription

end


