class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :title
      t.integer :position
      t.integer :articles_count, :default => 0
      t.timestamps
    end
    #Add Default Category
    c = Category.new(:title => "Default Category", :position => 1)
    c.id = 1
    c.save!
  end

  def self.down
    drop_table :categories
  end
end
