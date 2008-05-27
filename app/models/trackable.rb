class Trackable < ActiveRecord::Base
  
  named_scope :active, :conditions => "active = 1"
  
  belongs_to :subject, :polymorphic => true
  belongs_to :client
  
  def to_s
    subject_name
  end
  
end
