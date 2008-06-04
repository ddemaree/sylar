class AddTotalHoursToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :total_hours, :float, :default => 0
  end

  def self.down
    remove_column :tasks, :total_hours
  end
end
