class JournalEntry < ActiveRecord::Base
  cattr_accessor :current_user
  
  belongs_to :client
  belongs_to :trackable
  belongs_to :user
  
  validates_presence_of :client_id, :trackable_id
  
  before_validation :set_client_id_from_trackable
  before_validation :set_user_id
  acts_as_currency :rate
  
  named_scope :current_month, lambda { { :conditions => ["date BETWEEN ? AND ?", Date.today.beginning_of_month, Date.today.end_of_month] }  }
  
  def billable_hours
    billable ? hours : 0
  end
  
  def unbillable_hours
    billable ? 0 : hours
  end
  
protected

  def after_initialize
    self.hours    ||= 0
    self.date     ||= Date.today
    self.billable = true if self.billable.nil?
  end

  def set_client_id_from_trackable
    self.client_id = self.trackable.client_id if self.trackable
  end
  
  def set_user_id
    self.user = self.class.current_user
  end
  
end
