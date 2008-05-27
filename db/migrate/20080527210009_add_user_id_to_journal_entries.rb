class AddUserIdToJournalEntries < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :user_id, :integer
  end

  def self.down
    remove_column :journal_entries, :user_id
  end
end
