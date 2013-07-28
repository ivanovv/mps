json.array!(@articles) do |article|
  json.extract! article, :id, :name, :url
  json.excerpts raw(@excerpter.excerpt! article.content)
end