require File.dirname(__FILE__) + '/../test_helper'

class ImporterTest < ActiveSupport::TestCase
  
  def test_should_have_data
    #flunk csv_string_data
    data = csv_string_data
    
    importer = JournalEntry::Importer.from_string(data)
    
    flunk importer.inspect
  end
  
protected

  def csv_string_data
    @csv_string_data ||= File.read(RAILS_ROOT + "/test/fixtures/files/time-report.csv")
  end
  
end