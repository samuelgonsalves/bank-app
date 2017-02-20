Rails.application.routes.draw do
  
  root   'welcome#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users 
  #get '/edit' , to: 'users#edit'
  #get 'account_details' , to: 'users#account_details'
  #patch '/edit' , to: 'users#update' #CHECK!
  get 'users/:id/account' => 'users#account' , as: :account
  get 'users/:id/account_create_request' => 'users#account_create_request', as: :account_create_request
  get 'users/:id/search_for_users' => 'users#search_for_users', as: :search_for_users
  get 'users/:id/show_friends' => 'users#show_friends', as: :show_friends
 end
