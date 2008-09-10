class Period < ActiveRecord::Base
  
  validates_presence_of :year, :month
  validates_uniqueness_of :month, :scope => :year
  validates_numericality_of :year, :month
  
end
