Rails.application.routes.draw do
  
  root   'welcome#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  post 	 '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
<<<<<<< HEAD

  resources :users 
  #get '/edit' , to: 'users#edit'
  #get 'account_details' , to: 'users#account_details'
  #patch '/edit' , to: 'users#update' #CHECK!
  get 'users/:id/account' => 'users#account' , as: :account

 
=======
  resources :users


  get '/admins/' => 'admin#index', as: :admin_index
  get '/admins/:id' => 'admin#home', as: :admin_home
  #get '/admins/:id/edit' => 'admin#edit'
  
  get '/admins/:id/manage_accounts' => 'admin#manage_accounts', as: :manage_accounts
  get '/admins/:id/create_account' => 'admin#create_account', as: :create_account
  get '/admins/:id/view_accounts' => 'admin#view_accounts', as: :view_accounts
  get '/admins/:id/view_transaction_requests' => 'admin#view_transaction_requests', as: :view_transaction_requests
  
  get '/admins/:id/manage_users' => 'admin#manage_users', as: :manage_users
  get '/admins/:id/view_users' => 'admin#view_users', as: :view_users
  get '/admins/:id/view_transaction_history' => 'admin#view_transaction_history', as: :view_transaction_history
  get '/admins/:id/destroy_user' => 'admin#destroy_user', as: :destroy_user

  get '/admins/:id/manage_admins' => 'admin#manage_admins', as: :manage_admins
  get '/admins/:id/create_admin' => 'admin#create_admin', as: :create_admin
  get '/admins/:id/view_admins' => 'admin#view_admins', as: :view_admins


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
>>>>>>> dpatel12
end
