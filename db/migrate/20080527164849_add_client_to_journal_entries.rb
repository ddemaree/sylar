class AddClientToJournalEntries < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :client_id, :integer
  end

  def self.down
    remove_column :journal_entries, :client_id
  end
end
