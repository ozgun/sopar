class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :title
      t.text :body
      t.integer :is_published, :limit => 1, :default => 0
      t.references :article
      t.string :commentator, :commentator_email, :commentator_website
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
