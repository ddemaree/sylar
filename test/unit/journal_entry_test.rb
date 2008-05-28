require File.dirname(__FILE__) + '/../test_helper'

class JournalEntryTest < ActiveSupport::TestCase

  def test_auto_assignment_of_client_id
    client = clients(:practical)
    practical_trackable = trackables(:practical_trackable)
    
    assert_not_nil practical_trackable.client
    
    journal_entry = JournalEntry.new({
      :trackable => practical_trackable
    })
    
    assert journal_entry.valid?, journal_entry.errors.full_messages.join(", ")
    assert_not_nil journal_entry.client_id
    assert_equal client.id, journal_entry.client_id
  end
  
  def test_auto_assignment_of_rate
    client = clients(:practical)
    practical_trackable = trackables(:practical_trackable)
    
    journal_entry = JournalEntry.new({
      :trackable => practical_trackable,
      :hours     => 5.0,
      :rate_in_dollars => "0.0"
    })
    
    assert journal_entry.valid?
    assert_not_nil journal_entry.rate
    assert_equal   practical_trackable.rate, journal_entry.rate
  end
  
  def test_preservation_of_rate_for_extant_records
    entry = journal_entries(:entry_with_zero_rate)
    assert_equal 0, entry.rate
    
    entry.notes = "This is a change to the note"
    entry.rate  = "0.0"
    
    assert entry.valid?
    assert_equal 0, entry.rate
  end

end
