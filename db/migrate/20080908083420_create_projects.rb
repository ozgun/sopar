class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :title, :null => false
      t.text :description, :details, :demo_video
      t.integer :is_published, :is_finished, :limit => 1, :default => 0
      t.string :customer, :programming_language, :download_link, :website, :location, :demo_link
      t.datetime :started_at, :finished_at
      t.integer :hours_spent, :position
      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
