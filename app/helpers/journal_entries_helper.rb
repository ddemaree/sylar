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
  
  def date_navigation_link(direction=:previous)
    target_date =
      case direction
        when :previous then start_date - 1.month
        when :next then start_date + 1.month
        else start_date
      end
    
    text = target_date.strftime("%B %Y")
    text =
      case direction
        when :previous then "&laquo; #{text}"
        when :next then "#{text} &raquo;"
        else text
      end
    
    link_to text, {:year => target_date.year, :month => target_date.month}, :class => "date #{direction.to_s}"
  end
  
  def trackable_label(client, trackable)
    if trackable.subject == client
      return nil
    else
      return "#{content_tag(:strong, trackable, :class => "project")}: "
    end
  end
  
end
