class ArticlesController < ApplicationController
  respond_to :json, :js

  URLS = { 'text' => 'texts',  'persona' => 'personalii', 'thesaurus' => 'glossariy' }
  BASE_URL = 'http://app.papush.ru/'

  def index
    @articles = Article.search params[:q]
    #@articles.context.panes << ThinkingSphinx::Panes::ExcerptsPane
    @excerpter = ThinkingSphinx::Excerpter.new(
        'article_core',
        params[:q],
        {
            :before_match => '<span class="app_search_word">',
            :after_match  => '</span>'
        }
    )

    @articles = @articles.to_a
    @articles.each do|a|
      a.url = BASE_URL + URLS[(a.article_type || 'text')] + '/' + (a.url || '')
      a.article_type = case a.article_type
                         when 'persona' then "Персоналии"
                         when 'thesaurus' then "Глоссарий"
                         when 'text' then "Тексты"
                       end
    end
    respond_with @articles, :callback => params[:callback]
  end

end
