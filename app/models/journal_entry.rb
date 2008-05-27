class JournalEntry < ActiveRecord::Base
  
  belongs_to :client
  belongs_to :project
  
  validates_presence_of :client_id
  
  before_validation :set_client_id_from_project_if_blank
  
protected

  def after_initialize
    self.hours ||= 0
    self.date  ||= Date.today
  end

  def set_client_id_from_project_if_blank
    self.client_id ||= self.project.client_id if self.project
  end
  
end
