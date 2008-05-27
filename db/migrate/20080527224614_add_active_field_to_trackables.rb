class AddActiveFieldToTrackables < ActiveRecord::Migration
  def self.up
    add_column :trackables, :active, :boolean, :default => true
    add_column :projects,   :active, :boolean, :default => true
    add_column :clients,    :active, :boolean, :default => true
  end

  def self.down
    remove_column :trackables, :active
    remove_column :projects, :active
    remove_column :clients, :active
  end
end
