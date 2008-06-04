class AddTaskIdToJournalEntries < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :task_id, :integer
  end

  def self.down
    remove_column :journal_entries, :task_id
  end
end
