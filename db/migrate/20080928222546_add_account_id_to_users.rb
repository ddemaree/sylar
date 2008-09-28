class AddAccountIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account_id, :integer
    add_index :users, :account_id
  end

  def self.down
    remove_index :users, :account_id
    remove_column :users, :account_id
  end
end
