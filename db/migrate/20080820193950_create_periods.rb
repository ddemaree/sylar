class CreatePeriods < ActiveRecord::Migration
  def self.up
    create_table :periods do |t|
      t.integer :year
      t.integer :month
      t.float :hours
      t.integer :revenue
      t.float :target_hours
      t.integer :target_revenue

      t.timestamps
    end
  end

  def self.down
    drop_table :periods
  end
end
