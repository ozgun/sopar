class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :title, :null => false
      t.text :body, :cached_tag_list
      t.references :category, :user, :null => false
      t.integer :is_published, :comments_closed, :limit => 1, :default => 0
      t.integer :comments_count, :comments_published, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
