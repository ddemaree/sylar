class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :state
      t.text :description
      t.boolean :billable
      t.integer :trackable_id
      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
