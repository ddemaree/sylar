ActionController::Routing::Routes.draw do |map|
  
  map.resources :journal_entries
  map.resources :clients, :has_many => [:projects]
  
  map.resources :projects do |project|
    project.resources :journal_entries
  end
  
  map.resources :users
  map.resource :session

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'journal_entries'
end
