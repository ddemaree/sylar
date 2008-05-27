class Project < ActiveRecord::Base
  
  validates_presence_of :name, :client_id, :rate
  
  belongs_to :client
  
  acts_as_currency :rate
  
  def to_s
    name
  end
  
  def to_param
    "#{id}-#{name.gsub(/[^A-Za-z0-9-]+/,"-")}"
  end
  
end
