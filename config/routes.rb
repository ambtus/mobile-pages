MobilePages::Application.routes.draw do

  match '/tmp/test/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download' if Rails.env.test?
  match '/tmp/development/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download' if Rails.env.development?
  match '/files/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download' if Rails.env.production?
  match '/login' => 'sessions#login', :as => 'login'

  resources :authors, :only => ['show', 'create']
  resources :genres
  resources :hiddens
  resources :htmls, :only => ['edit']
  resources :notes, :only => ['edit']
  resources :pages
  resources :parts, :only => ['new', 'edit', 'create']
  resources :rates, :only => ['show', 'create']
  resources :refetches, :only => ['show', 'create']
  resources :scrubs, :only => ['show']
  resources :sessions, :only => ['login', 'create']

  root :to => 'pages#index'
end
