class CreateTrackables < ActiveRecord::Migration
  def self.up
    create_table :trackables do |t|
      t.string :subject_type
      t.integer :subject_id
      t.string :subject_name
      t.integer :client_id
      t.timestamps
    end
  end

  def self.down
    drop_table :trackables
  end
end
