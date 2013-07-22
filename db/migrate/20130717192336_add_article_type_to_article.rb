class AddArticleTypeToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :article_type, :string
  end
end
