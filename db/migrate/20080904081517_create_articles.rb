class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title, :null => false
      t.text :body
      t.references :category, :user, :null => false
      t.integer :is_published, :limit => 1, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
