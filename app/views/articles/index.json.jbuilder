json.array!(@articles) do |article|
  json.extract! article, :id, :name, :url, :article_type
  json.excerpts raw(@excerpter.excerpt! article.content)
end