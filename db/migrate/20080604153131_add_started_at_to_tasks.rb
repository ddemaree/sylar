class AddStartedAtToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :started_at, :datetime
  end

  def self.down
    remove_column :tasks, :started_at
  end
end
