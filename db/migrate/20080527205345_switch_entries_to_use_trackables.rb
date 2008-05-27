class SwitchEntriesToUseTrackables < ActiveRecord::Migration
  def self.up
    add_column :journal_entries, :trackable_id, :integer
    remove_column :journal_entries, :project_id
  end

  def self.down
    remove_column :journal_entries, :trackable_id
    add_column :journal_entries, :project_id, :integer
  end
end
