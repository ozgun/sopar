class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :limit => 40
      t.string :email, :crypted_password
      t.string :first_name, :last_name, :limit => 50
      t.text :biography
      t.datetime :last_logged_in_at, :remember_token_expires_at
      t.string :remember_token, :salt, :website
      t.integer :deactivated, :limit => 1, :default => 0
      t.timestamps
    end
    # Add indexes
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
    add_index :users, :remember_token

    # Create default admin
    u = User.new(:username => "admin", :password => "admin", :password_confirmation => "admin", 
                 :email => "admin@example.com", :first_name => "Site", :last_name => "Admin",
                 :biography => "Site Admin...", :website => "example.com")
    u.id = 1
    u.save!
  end

  def self.down
    drop_table :users
  end
end
