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

ActiveRecord::Schema.define(:version => 20080907103518) do

  create_table "articles", :force => true do |t|
    t.string   "title",                            :default => "", :null => false
    t.text     "body"
    t.integer  "category_id",        :limit => 11,                 :null => false
    t.integer  "user_id",            :limit => 11,                 :null => false
    t.integer  "is_published",       :limit => 1,  :default => 0
    t.integer  "comments_closed",    :limit => 1,  :default => 0
    t.integer  "comments_count",     :limit => 11, :default => 0
    t.integer  "comments_published", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets", :force => true do |t|
    t.integer  "parent_id",    :limit => 11
    t.integer  "size",         :limit => 11
    t.integer  "width",        :limit => 11
    t.integer  "height",       :limit => 11
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.integer  "position",       :limit => 11
    t.integer  "articles_count", :limit => 11, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "is_published",        :limit => 1,  :default => 0
    t.integer  "article_id",          :limit => 11
    t.string   "commentator"
    t.string   "commentator_email"
    t.string   "commentator_website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_prefs", :force => true do |t|
    t.string   "title"
    t.string   "slogan"
    t.string   "email"
    t.string   "domain"
    t.text     "footer"
    t.text     "sidebar"
    t.text     "google_analytics"
    t.text     "google_adsense"
    t.text     "gtalk_badge"
    t.text     "links"
    t.text     "twitter"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "static_pages", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "is_published", :limit => 1, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :limit => 11
    t.integer  "taggable_id",   :limit => 11
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                  :limit => 40
    t.string   "email"
    t.string   "crypted_password"
    t.string   "first_name",                :limit => 50
    t.string   "last_name",                 :limit => 50
    t.text     "biography"
    t.datetime "last_logged_in_at"
    t.datetime "remember_token_expires_at"
    t.string   "remember_token"
    t.string   "salt"
    t.string   "website"
    t.integer  "deactivated",               :limit => 1,  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
