class AddRateToClients < ActiveRecord::Migration
  def self.up
    add_column :trackables, :rate, :integer, :default => 0
    add_column :clients, :rate, :integer, :default => 0
    
    Project.find(:all).each { |p| p.save }
    Client.find(:all).each { |c| c.save }
  end

  def self.down
    remove_column :trackables, :rate
    remove_column :clients, :rate
  end
end
