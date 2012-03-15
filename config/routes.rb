MobilePages::Application.routes.draw do

  match '/test/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download'
  match '/development/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download'
  match '/files/:modulo/:id/downloads/:download_title.:format' => 'downloads#show', :as => 'download'

  resources :authors, :only => ['show', 'create']
  resources :genres, :only => ['show', 'create']
  resources :htmls, :only => ['edit']
  resources :notes, :only => ['edit']
  resources :pages
  resources :parts, :only => ['new', 'edit', 'create']
  resources :rates, :only => ['show', 'create']
  resources :refetches, :only => ['show', 'create']
  resources :scrubs, :only => ['show']

  root :to => 'pages#index'
end
