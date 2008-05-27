module ActsAsTrackable
  
  def self.included(base)
    base.class_eval do
      named_scope :active, :conditions => ["active = ?", true], :order => "name ASC"
      has_one :trackable, :as => :subject
      after_save :update_trackable
      after_destroy :destroy_trackable
    end
  end
  
  def update_trackable
    trackable = (self.trackable || self.build_trackable)
    trackable.client = self.to_client
    trackable.subject_name = self.to_subject_name
    trackable.active = self.active
    trackable.save
  end
  
  def destroy_trackable
    self.trackable.destroy
  end
  
  def to_client
    self.client
  end
  
  def to_subject_name
    self.to_s
  end
  
end