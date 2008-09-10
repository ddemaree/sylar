module TimeEntriesHelper
  
  def group_by_param(entries)
    @grouped_entries =
      case params[:group_by]
        when "project" then JournalEntry::Analyzer.group_by_project(entries)
        else JournalEntry::Analyzer.group_by_date(entries)
      end
  end
  
  def header_text(header_obj)
    case header_obj
      when Date then header_obj.strftime("%A, %B %e")
      else header_obj.to_s
    end
  end
  
  def group_by_date_with_empties(collection, options={})
     base_set = collection.group_by(&:date)
     days = (Date.today.beginning_of_month..Date.today).inject({}) { |c, d| c[d] = []; c }
     days.update(base_set).sort { |a, b| b[0] <=> a[0] }
   end

   def trackable_options
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
         when :previous then "#{text}"
         when :next then "#{text}"
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
