class AddContentFieldsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :source, :text
    add_column :articles, :result, :text
  end
end
