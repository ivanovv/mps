json.array!(@articles) do |article|
  json.extract! article, :id, :name, :url, :article_type, :parent_link, :excerpts
end