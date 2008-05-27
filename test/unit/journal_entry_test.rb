require File.dirname(__FILE__) + '/../test_helper'

class JournalEntryTest < ActiveSupport::TestCase

  def test_auto_assignment_of_client_id
    client = clients(:blue_box)
    project = projects(:blue_box_project)
    
    journal_entry = JournalEntry.new({
      :project => project
    })
    
    assert journal_entry.valid?
    assert_not_nil journal_entry.client_id
    assert_equal client.id, journal_entry.client_id
  end

end
