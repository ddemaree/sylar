class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.integer :client_id
      t.string :name
      t.integer :rate

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
