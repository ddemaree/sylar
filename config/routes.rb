ActionController::Routing::Routes.draw do |map|
  map.resources :tasks

  map.resources :clients, :has_many => [:projects, :tasks]
  
  map.dated_log '/:year/:month/time_entries', :year => /\d{4}/, :month => /\d{1,2}/, :controller => 'time_entries', :action => 'index'
  map.formatted_dated_log '/:year/:month/time_entries.:format', :year => /\d{4}/, :month => /\d{1,2}/, :controller => 'time_entries', :action => 'index'
  
  map.dated_stats '/statistics/:year/:month', :year => /\d{4}/, :month => /\d{1,2}/, :controller => 'statistics', :action => 'index'
  map.formatted_dated_stats '/:year/:month/statistics.:format', :year => /\d{4}/, :month => /\d{1,2}/, :controller => 'statistics', :action => 'index'
  
  map.with_options :controller => "time_entries" do |te|
    te.connect 'journal_entries/:year/:month', :year => /\d{4}/, :month => /\d{1,2}/, :action => 'index'
    
    te.connect 'time_entries/import', :action => 'handle_import', :conditions => {:method => :post}
    te.connect 'time_entries/import', :action => 'import', :conditions => {:method => :get}
    
    
    te.resources :journal_entries, :time_entries
    
    
  end
  
  map.resources :projects do |project|
    project.resources :journal_entries
    project.resources :tasks
  end
  
  map.resources :users
  map.resource :session

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
  map.root :controller => 'time_entries'
end
