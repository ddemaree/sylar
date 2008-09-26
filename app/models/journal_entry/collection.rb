class JournalEntry::Collection < Array
  
  def self.create(&block)
    pager = new #(page, per_page, total)
    yield pager
    pager
  end
  
  def self.create_from_array(entries=[])
    return new.replace(entries)
  end
  
  def hours
    @hours ||= self.sum(&:hours)
  end
  
  def revenue
    @revenue ||= self.sum(&:revenue)
  end
  
  def revenue_in_dollars
    self.revenue.to_f / 100.0
  end
  
  def group_by
    assoc = ActiveSupport::OrderedHash.new
  
    each do |element|
      key = yield(element)
  
      if assoc.has_key?(key)
        assoc[key] << element
      else
        assoc[key] = self.class.create_from_array([element])
      end
    end
  
    assoc
  end
  
  def collate_by(param=:date)
    send("collate_by_#{param}".to_sym)
  end
  
  def collate_by_project
    entries_by_client = self.group_by(&:client).sort { |a,b| a.first.name <=> b.first.name }
    entries_by_client.inject({}) do |coll, hash|
      client, entries = hash
      coll[client] = entries.group_by(&:trackable).sort { |a,b| a.first.to_s <=> b.first.to_s }
      
      coll
    end.sort { |a,b| a.first.name <=> b.first.name }
  end
  
  def collate_by_date
    entries_by_day = self.group_by(&:date).sort { |a, b| b[0] <=> a[0] }
    entries_by_day.inject({}) do |coll, hash|
      day, entries = hash
      
      coll[day] = entries.group_by(&:client).sort { |a,b| a.first.name <=> b.first.name }
      
      coll
    end.sort { |a, b| b[0] <=> a[0] }
  end
  
end