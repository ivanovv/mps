json.array!(@articles) do |article|
  json.extract! article, :id, :name, :url, :article_type
  json.excerpts raw(@excerpter.excerpt! article.content)
  json.parent_link article.object.article_type == 'persona' ? 'personas.html' : 'thesaurus.html'
end