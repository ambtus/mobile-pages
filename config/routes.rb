Rails.application.routes.draw do

  get '/mini' => "pages#minimal", as: :mini
  root to: redirect('/mini', status: 302)

  get '/reading' => "pages#reading", as: :reading
  get '/soonest' => "pages#soonest", as: :soonest
  get '/soon' => "pages#soon", as: :soon
  get '/filter' => "pages#filter", as: :filter
  post '/find' => "pages#find", as: :find

  resources :pages
  resources :tags
  resources :htmls, :only => ['edit']
  resources :notes, :only => ['edit', 'show']
  resources :my_notes, :only => ['edit']
  resources :parts, :only => ['new', 'edit', 'create']
  resources :rates, :only => ['show', 'create', 'edit']
  resources :refetches, :only => ['show', 'create']
  resources :scrubs, :only => ['show']

  get '/downloads/:id.:format' => 'downloads#show', :as => 'download'

end
