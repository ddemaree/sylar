class Task < ActiveRecord::Base
  
  belongs_to :trackable
  belongs_to :user
  has_many :journal_entries
  #has_many :task_states
  
  validates_presence_of :trackable, :user
  
  acts_as_state_machine :initial => :open
  
  state :open, :enter => :suspend_all_open_tasks, :exit => :create_time_record
  state :sleeping
  state :finished
  
  event :sleep do
    transitions :to => :sleeping, :from => [:open, :sleeping, :finished]
  end
  
  event :wake do
    transitions :to => :open, :from => [:sleeping, :finished]
  end
  
  event :finish do
    transitions :to => :finished, :from => [:sleeping, :open]
  end
  
  def hours
    (Time.now - self.started_at).to_i / 3600.0
  end
  
protected

  def suspend_all_open_tasks
    self.user.tasks.open.each do |open_task|
      open_task.sleep! unless open_task == self
    end
    
    self.started_at = Time.zone.now
  end
  
  def create_time_record
    self.journal_entries.create({
      :notes => self.description,
      :hours => self.hours,
      :date  => Time.zone.now.to_date,
      :billable => !!self.billable,
      :trackable => self.trackable,
      :user => self.user
    })
    
    self.total_hours = ("%0.2f" % self.journal_entries.sum(:hours))
  end
  
end
