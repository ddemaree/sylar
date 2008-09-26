require 'fastercsv'

class Array
  def merge_into_hash(anArray)
    tmp,hash = anArray.dup,{}
    self.each {|key| hash[key] = tmp.shift}
    hash
  end
end

class JournalEntry::Importer
  
  def self.from_string(csv_string)
    new(csv_string)
  end
  
  def self.from_path(filename)
    new(File.read(filename))
  end
  
  def self.from_file(file)
    new(file.read)
  end
  
  def initialize(data)
    @data = data
    @rows = []
    parse!
  end
  
  def inspect
    @rows
  end
  
  def parse!
    csv_array = FasterCSV.parse(@data)
    columns   = csv_array.shift
    csv_array.each do |row|
      @rows << columns.merge_into_hash(row)
    end
    @rows
  end
  
  def rows
    @rows
  end
  
  def data
    @data
  end
  
end