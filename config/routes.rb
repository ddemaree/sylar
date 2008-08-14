ActionController::Routing::Routes.draw do |map|
  map.resources :tasks

  map.resources :clients, :has_many => [:projects, :tasks]
  
  map.connect 'journal_entries/:year/:month', :year => /\d{4}/, :month => /\d{1,2}/, :controller => 'journal_entries', :action => 'index'
  map.resources :journal_entries
  
  map.resources :projects do |project|
    project.resources :journal_entries
    project.resources :tasks
  end
  
  map.resources :users
  map.resource :session

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'journal_entries'
end
