ActionController::Routing::Routes.draw do |map|
  map.resources :pages
  map.resources :authors
  map.resources :genres
  map.resources :start
  map.resources :store
  map.resources :scrub
  map.resources :refetch
  map.resources :rate
  map.resources :search
  map.resources :parts
  map.resources :html
  map.resources :notes
  map.root :controller => "start"
end
