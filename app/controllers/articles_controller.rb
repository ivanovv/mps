class ArticlesController < ApplicationController
  respond_to :json

  URLS = { 'text' => 'texts',  'persona' => 'personalii', 'thesaurus' => 'glossariy' }
  BASE_URL = 'http://gerome.ru/mp2/'

  def index
    @articles = Article.search(params[:q]).to_a
    @articles.each {|a| a.url = BASE_URL + URLS[(a.article_type || 'text')] + '/' + (a.url || '') }
    respond_with @articles
  end

end
