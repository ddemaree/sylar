class ChangeSomeStuffAboutJournalEntries < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :hours, :float
    remove_column :journal_entries, :start_time
    remove_column :journal_entries, :end_time
  end

  def self.down
    remove_column :journal_entries, :hours
    add_column :journal_entries, :start_time, :time
    add_column :journal_entries, :end_time, :time
  end
end
