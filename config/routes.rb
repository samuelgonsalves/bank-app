Rails.application.routes.draw do
<<<<<<< HEAD
  get 'users/new'

  get '/home' , to: 'static_pages#home'

  get '/help' , to: 'static_pages#help'

  get '/about' , to: 'static_pages#about'

  get '/contact' , to: 'static_pages#contact'

  get '/signup' , to: 'users#new'

  get '/edit' , to: 'users#edit'

  get 'users/:id/account_details' , to: 'users#account_details'
 
  patch '/edit' , to: 'users#update' #CHECK!

  post '/signup' , to: 'users#create'
  
=======
  root   'welcome#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
>>>>>>> dea1d33ec63df3811be41d87ff2aa96764cb9c5c
  resources :users
end
