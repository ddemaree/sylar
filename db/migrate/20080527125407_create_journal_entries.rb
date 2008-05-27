class CreateJournalEntries < ActiveRecord::Migration
  def self.up
    create_table :journal_entries do |t|
      t.integer :project_id
      t.text :notes
      t.time :start_time
      t.time :end_time
      t.date :date
      t.boolean :billable
      t.integer :rate

      t.timestamps
    end
  end

  def self.down
    drop_table :journal_entries
  end
end
