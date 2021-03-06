# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080820193950) do

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "contact_name"
    t.string   "contact_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",        :default => true
    t.integer  "rate",          :default => 0
  end

  create_table "journal_entries", :force => true do |t|
    t.text     "notes"
    t.date     "date"
    t.boolean  "billable"
    t.integer  "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "client_id"
    t.float    "hours"
    t.integer  "trackable_id"
    t.integer  "user_id"
    t.integer  "task_id"
  end

  create_table "periods", :force => true do |t|
    t.integer  "year"
    t.integer  "month"
    t.float    "hours"
    t.integer  "revenue"
    t.float    "target_hours"
    t.integer  "target_revenue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.integer  "client_id"
    t.string   "name"
    t.integer  "rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     :default => true
  end

  create_table "tasks", :force => true do |t|
    t.string   "state"
    t.text     "description"
    t.boolean  "billable"
    t.integer  "trackable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "started_at"
    t.float    "total_hours",  :default => 0.0
    t.integer  "client_id"
  end

  create_table "trackables", :force => true do |t|
    t.string   "subject_type"
    t.integer  "subject_id"
    t.string   "subject_name"
    t.integer  "client_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",       :default => true
    t.integer  "rate",         :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
