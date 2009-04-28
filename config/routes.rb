ActionController::Routing::Routes.draw do |map|
  map.resources :start
  map.resources :store
  map.resources :pages
  map.resources :scrub
  map.root :controller => "start"
end
