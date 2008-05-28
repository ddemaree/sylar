class JournalEntry < ActiveRecord::Base
  cattr_accessor :current_user
  
  belongs_to :client
  belongs_to :trackable
  belongs_to :user
  
  validates_presence_of :client_id, :trackable_id
  
  before_validation :set_client_id_from_trackable
  before_validation :set_user_id
  before_validation_on_create  :set_rate
  
  acts_as_currency :rate
  
  named_scope :current_month, lambda { { :conditions => ["date BETWEEN ? AND ?", Date.today.beginning_of_month, Date.today.end_of_month] }  }
  
  named_scope :billable, :conditions => ["billable = ?", true]
  named_scope :unbillable, :conditions => ["billable = ?", false]
  
  named_scope :by_month, lambda { |date| { :conditions => ["date BETWEEN ? AND ?", date.to_date.beginning_of_month, date.to_date.end_of_month] } }
  
  def self.grouped_by_day(date=Date.today)
    entries = by_month(date).group_by(&:date)
    
    start_date = date.beginning_of_month
    end_date   = (start_date.month == Date.today.month) ? Date.today : date.end_of_month
    
    days = (start_date..end_date).inject({}) { |c, d| c[d] = []; c }
    days.update(entries).sort { |a, b| b[0] <=> a[0] }
  end
  
  def billable_hours
    billable ? hours : 0
  end
  
  def unbillable_hours
    billable ? 0 : hours
  end
  
  def self.hours
    sum(:hours)
  end
  
protected

  def after_initialize
    self.hours    ||= 0
    self.date     ||= Date.today
    self.billable = true if self.billable.nil?
    
    if self.trackable
      self.rate ||= self.trackable.rate
    end
  end

  def set_client_id_from_trackable
    self.client_id = self.trackable.client_id if self.trackable
  end
  
  def set_user_id
    self.user = self.class.current_user
  end
  
  def set_rate
    self.rate = self.trackable.rate if self.trackable && self.rate == 0
  end
  
end
