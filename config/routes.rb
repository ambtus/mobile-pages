ActionController::Routing::Routes.draw do |map|
  map.resources :pages
  map.resources :read
  map.resources :authors
  map.resources :genres
  map.resources :store
  map.resources :scrub
  map.resources :refetch
  map.resources :rate
  map.resources :parts
  map.resources :html
  map.resources :notes
  map.root :controller => "pages"
end
