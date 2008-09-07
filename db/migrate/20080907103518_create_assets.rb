class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.integer :parent_id, :size, :width, :height
      t.string :content_type, :filename, :thumbnail, :title
      t.timestamps
    end
  end

  def self.down
    drop_table :assets
  end
end
