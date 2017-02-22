Rails.application.routes.draw do
  
  root   'welcome#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post 	 '/signup',  to: 'users#create'
  post	 '/signup_admin' => 'admin#create', as: :signup_admin
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
  get '/users/current_user/transfer_money/:id' => 'users#transfer_money', as: :transfer_money
  post '/users/current_user/transfer_money/:id' => 'users#transfer_money'
  get '/users/current_user/deposit' => 'users#deposit', as: :deposit
  post '/users/current_user/deposit' => 'users#deposit'

  get '/users/current_user/withdraw' => 'users#withdraw', as: :withdraw
  post '/users/current_user/withdraw' => 'users#withdraw'

  get '/users/current_user/add_friend/:id' => 'users#add_friend', as: :add_friend


  get '/admins/' => 'admin#index', as: :admin_index
  get '/admins/home' => 'admin#home', as: :admin_home
  #get '/admins/:id/edit' => 'admin#edit'
  
  get '/admins/manage_accounts' => 'admin#manage_accounts', as: :manage_accounts
  get '/admins/manage_accounts/create_accounts' => 'admin#create_accounts', as: :create_accounts
  get '/admins/manage_accounts/create_accounts/approve_or_decline_account' => 'admin#approve_or_decline_account', as: :approve_or_decline_account
  get '/admins/manage_accounts/view_accounts' => 'admin#view_accounts', as: :view_accounts
  get '/admins/manage_accounts/view_accounts/view_account_details/:id' => 'admin#view_account_details', as: :view_account_details
  get '/admins/manage_accounts/view_transaction_requests' => 'admin#view_transaction_requests', as: :view_transaction_requests
  get '/admins/manage_accounts/view_transaction_requests/approve_or_decline_transaction' => 'admin#approve_or_decline_transaction', as: :approve_or_decline_transaction
  get '/admins/manage_accounts/view_accounts/delete_account/:id' => 'admin#delete_account', as: :delete_account  
 
  get '/admins/manage_users' => 'admin#manage_users', as: :manage_users
  get '/admins/view_users' => 'admin#view_users', as: :view_users
  get '/admins/view_transaction_history/:id' => 'admin#view_transaction_history', as: :view_transaction_history
  get '/admins/destroy_user/:id' => 'admin#destroy_user', as: :destroy_user

  get '/admins/manage_admins' => 'admin#manage_admins', as: :manage_admins
  get '/admins/create_admin' => 'admin#create_admin', as: :create_admin
  get '/admins/view_admins' => 'admin#view_admins', as: :view_admins
  get '/admins/view_admins/delete_admin/:id' => 'admin#delete_admin', as: :delete_admin
  
end

