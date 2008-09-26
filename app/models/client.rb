class Client < ActiveRecord::Base
  include ActsAsTrackable
  
  has_many :trackables
  has_many :projects
  has_many :journal_entries, :through => :projects
  
  validates_presence_of :name, :contact_name, :contact_email
  
  def to_s
    name
  end
  
  def to_param
    "#{id}-#{name.gsub(/[^A-Za-z0-9-]+/,"-")}"
  end
  
  def to_client
    self
  end
  
  def to_subject_name
    "[#{name}]"
  end
  
  def <=>(other)
    self.name <=> other.name
  end
  
  def to_json(*args)
    {
      :name => name,
      :id   => id,
      :rate => rate,
      :trackable_id => trackable.id,
      :trackables => trackables.select { |t| t.subject_type != "Client" }
    }.to_json
  end
  
end
