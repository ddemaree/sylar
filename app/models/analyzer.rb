class Analyzer
  
  def self.hours_by_day(journal_entries)
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
    entries_by_client = journal_entries.collect(&:last).flatten.group_by(&:client)
  
    sums =
      entries_by_client.inject({}) do |coll, hash|
        client, entries = hash
        sum = entries.collect(&:hours).sum
        coll[client] = {:hours => sum, :total => (sum * (client.rate / 100.0))}
        coll
      end
      
    sums.sort { |a, b| a.last[:total] <=> b.last[:total] }.reverse
  end
  
end