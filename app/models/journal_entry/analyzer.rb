class JournalEntry::Analyzer
  
  def self.group_by_date(entries)
    entries_by_day = entries.group_by(&:date).sort { |a, b| b[0] <=> a[0] }
    entries_by_day.inject({}) do |coll, hash|
      day, entries = hash
      
      coll[day] = entries.group_by(&:client).sort { |a,b| a.first.name <=> b.first.name }
      
      coll
    end.sort { |a, b| b[0] <=> a[0] }
  end
  
  def self.group_by_project(entries)
    entries_by_client = entries.group_by(&:client).sort { |a,b| a.first.name <=> b.first.name }
    entries_by_client.inject({}) do |coll, hash|
      client, entries = hash
      coll[client] = entries.group_by(&:trackable).sort { |a,b| a.first.to_s <=> b.first.to_s }
      
      coll
    end.sort { |a,b| a.first.name <=> b.first.name }
  end
  
  def self.hours_by_day(journal_entries)
    journal_entries = group_by_day(journal_entries)
    
    returning({}) do |coll|
      journal_entries.each do |day, entries|
        coll[day] =
          if entries.empty?
            0.0
          else
            entries.collect(&:hours).sum
          end
      end
    end.sort.reverse
  end
  
  def self.hours_by_client(journal_entries)
    entries_by_client = journal_entries.group_by(&:client)
  
    sums =
      entries_by_client.inject({}) do |coll, hash|
        client, entries = hash
        sum = entries.collect(&:hours).sum
        coll[client] = {:hours => sum, :total => (sum * (client.rate / 100.0))}
        coll
      end
      
    sums.sort { |a, b| a.last[:total] <=> b.last[:total] }.reverse
  end
  
  def self.group_by_day(entries,date=Date.today)
    entries = entries.group_by(&:date)
    
    start_date = date.beginning_of_month
    end_date   = (start_date.month == Date.today.month) ? Date.today : date.end_of_month
    
    days = (start_date..end_date).inject({}) { |c, d| c[d] = []; c }
    days.update(entries).sort { |a, b| b[0] <=> a[0] }
  end
  
end