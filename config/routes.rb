Rails.application.routes.draw do

  get '/tmp/test/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download' if Rails.env.test?
  get '/tmp/files/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download' if Rails.env.development?
  get '/files/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download' if Rails.env.production?
  match '/login' => 'sessions#login', :as => 'login', via: [:get, :post]

  resources :tags
  resources :htmls, :only => ['edit']
  resources :notes, :only => ['edit', 'show']
  resources :my_notes, :only => ['edit']
  resources :pages
  resources :parts, :only => ['new', 'edit', 'create']
  resources :rates, :only => ['show', 'create', 'edit']
  resources :refetches, :only => ['show', 'create']
  resources :scrubs, :only => ['show']

  root :to => 'pages#index'
end
