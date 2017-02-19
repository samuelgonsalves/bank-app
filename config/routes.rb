Rails.application.routes.draw do
  
  root   'welcome#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/edit' , to: 'users#edit'
  get 'users/:id/account_details' , to: 'users#account_details'
  patch '/edit' , to: 'users#update' #CHECK!


  resources :users
end
