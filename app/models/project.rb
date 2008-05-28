class Project < ActiveRecord::Base
  include ActsAsTrackable
  
  validates_presence_of :name, :client_id, :rate
  
  belongs_to :client
  
  def to_s
    name
  end
  
  def to_param
    "#{id}-#{name.gsub(/[^A-Za-z0-9-]+/,"-")}"
  end
  
end
