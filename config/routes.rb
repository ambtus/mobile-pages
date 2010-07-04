MobilePages::Application.routes.draw do |map|
  devise_for :users

  resources :authors, :only => ['show', 'create']
  resources :genres, :only => ['show', 'create']
  resources :htmls, :only => ['edit'] 
  resources :notes, :only => ['edit']
  resources :pages, :only => ['index', 'show', 'create', 'update']
  resources :parts, :only => ['new', 'edit', 'create']
  resources :rates, :only => ['show', 'create']
  resources :reads, :only => ['show']
  resources :refetches, :only => ['show', 'create']
  resources :scrubs, :only => ['show']

  root :to => 'pages#index'
end
