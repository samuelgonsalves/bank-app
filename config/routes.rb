Rails.application.routes.draw do
  
  root   'welcome#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post 	 '/signup',  to: 'users#create'
  post	 '/signup_admin' => 'admins#create', as: :signup_admin
  get    '/login',   to: 'sessions#new', as: :login
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :users 
  #get '/edit' , to: 'users#edit'
  #get 'account_details' , to: 'users#account_details'
  #patch '/edit' , to: 'users#update' #CHECK!
  get 'users/current_user/account' => 'users#account' , as: :account

  get '/users/current_user/account_create_request' => 'users#account_create_request', as: :account_create_request
  get '/users/current_user/search_for_users' => 'users#search_for_users', as: :search_for_users
  get '/users/current_user/show_friends' => 'users#show_friends', as: :show_friends
  get '/users/current_user/show_transactions' => 'users#show_transactions', as: :show_transactions

  get '/users/current_user/cancel/:id' => 'users#cancel', as: :cancel
  get '/users/current_user/borrow_requests' => 'users#borrow_requests', as: :borrow_requests

  get '/users/current_user/transfer_money/:id' => 'users#transfer_money', as: :transfer_money
  post '/users/current_user/transfer_money/:id' => 'users#transfer_money'

  get '/users/current_user/borrow_money/:id' => 'users#borrow_money', as: :borrow_money
  post '/users/current_user/borrow_money/:id' => 'users#borrow_money'

  get '/users/current_user/deposit' => 'users#deposit', as: :deposit
  post '/users/current_user/deposit' => 'users#deposit'

  get '/users/current_user/withdraw' => 'users#withdraw', as: :withdraw
  post '/users/current_user/withdraw' => 'users#withdraw'

  get '/users/current_user/add_friend/:id' => 'users#add_friend', as: :add_friend


  get '/admins/' => 'admins#index', as: :admin_index
  get '/admins/home' => 'admins#home', as: :admin_home
  
  #get '/admins/:id/edit' => 'admins#edit'
  
  get '/admins/manage_accounts' => 'admins#manage_accounts', as: :manage_accounts
  get '/admins/manage_accounts/create_accounts' => 'admins#create_accounts', as: :create_accounts
  get '/admins/manage_accounts/create_accounts/approve_or_decline_account' => 'admins#approve_or_decline_account', as: :approve_or_decline_account
  get '/admins/manage_accounts/view_accounts' => 'admins#view_accounts', as: :view_accounts
  get '/admins/manage_accounts/view_accounts/view_account_details/:id' => 'admins#view_account_details', as: :view_account_details
  get '/admins/manage_accounts/view_accounts/view_account_details/view_transaction_history/:id' => 'admins#view_transaction_history', as: :view_transaction_history

  get '/admins/manage_accounts/view_transaction_requests' => 'admins#view_transaction_requests', as: :view_transaction_requests
  get '/admins/manage_accounts/view_transaction_requests/approve_or_decline_transaction' => 'admins#approve_or_decline_transaction', as: :approve_or_decline_transaction
  get '/admins/manage_accounts/view_accounts/delete_account/:id' => 'admins#delete_account', as: :delete_account  
 
  get '/admins/manage_users' => 'admins#manage_users', as: :manage_users
  get '/admins/view_users' => 'admins#view_users', as: :view_users
  get '/admins/view_transaction_history_of_user/:id' => 'admins#view_transaction_history_of_user', as: :view_transaction_history_of_user
  get '/admins/destroy_user/:id' => 'admins#destroy_user', as: :destroy_user

  get '/admins/manage_admins' => 'admins#manage_admins', as: :manage_admins
  get '/admins/create_admin' => 'admins#create_admin', as: :create_admin
  get '/admins/view_admins' => 'admins#view_admins', as: :view_admins
  get '/admins/view_admins/delete_admin/:id' => 'admins#delete_admin', as: :delete_admin
  
end

