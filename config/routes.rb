ActionController::Routing::Routes.draw do |map|
  map.resources :start
  map.resources :store
  map.resources :pages
  map.resources :scrub
  map.resources :search
  map.root :controller => "start"
  map.file '/:environment/:modulo/:id/:filename.txt', :controller => "files", :action => 'show'
end
