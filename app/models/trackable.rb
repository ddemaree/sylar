class Trackable < ActiveRecord::Base
  
  belongs_to :subject, :polymorphic => true
  belongs_to :client
  
  def to_s
    subject_name
  end
  
end
