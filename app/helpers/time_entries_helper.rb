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
  
  
  
  
  
end
