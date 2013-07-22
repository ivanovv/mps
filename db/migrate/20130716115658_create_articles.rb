class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :name
      t.text :content
      t.string :url
      t.string :resource_id
      t.string :resource_type

      t.timestamps
    end
  end
end
