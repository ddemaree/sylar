class Trackable < ActiveRecord::Base
  
  named_scope :active, :conditions => {:active => true}
  
  belongs_to :subject, :polymorphic => true
  belongs_to :client
  
  def to_s
    subject_name
  end
  
  def option_name
    case subject_type
      when "Client" then subject_name
      else "&nbsp;  #{subject_name}"
    end
  end
  
  def self.options_for_select
    #find(:all).sort {|a, b| a.client_id <=> b.client_id }.collect {|tt| [tt.subject_name, tt.id] }
    
    trackables = find(:all, :order => "subject_type ASC")
    grouped_set = trackables.group_by(&:subject_type)
    grouped_set.inject({}) do |coll, hash|
      type, entries = hash
      coll[type] = entries.collect {|tt| [tt.option_name, tt.id] }
      coll
    end
  end
  
end
