ActionController::Routing::Routes.draw do |map|
  map.resources :pages
  map.resources :genres
  map.resources :start
  map.resources :store
  map.resources :scrub
  map.resources :rate
  map.resources :search
  map.resources :parts
  map.resources :notes
  map.root :controller => "start"
  map.file '/:environment/:modulo/:id/:filename.txt', :controller => "files", :action => 'show'
end
