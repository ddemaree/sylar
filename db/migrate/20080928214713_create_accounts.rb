class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name
      t.string :timezone
      t.string :subdomain
      t.string :business_type

      t.timestamps
    end
  end

  def self.down
    drop_table :accounts
  end
end
