class Client < ActiveRecord::Base
  
  has_many :projects
  has_many :journal_entries, :through => :projects
  
  validates_presence_of :name, :contact_name, :contact_email
  
  def to_s
    name
  end
  
  def to_param
    "#{id}-#{name.gsub(/[^A-Za-z0-9-]+/,"-")}"
  end
  
end
