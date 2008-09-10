class CreateScreenshots < ActiveRecord::Migration
  def self.up
    create_table :screenshots do |t|
      t.integer :parent_id, :size, :width, :height
      t.string :content_type, :filename, :thumbnail, :title
      t.references :project
      t.timestamps
    end
  end

  def self.down
    drop_table :screenshots
  end
end
