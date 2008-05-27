module JournalEntriesHelper
  
  def trackable_options
    #trackables = Trackable.find(:all, :order => "client_id ASC")
    #trackables.collect { |t| [(t.subject_type == "Project" ? "-   #{t.subject_name}" : t.to_s), t.id]  }
    
    returning([]) do |options|
      Client.active(:order => "name ASC").each do |client|
        options << [client.name, client.trackable.id]
        client.projects.each do |project|
          options << [" - #{project.name}", project.trackable.id]
        end
      end
    end
  end
  
end
