class ArticlesController < ApplicationController
  respond_to :json

  before_action :set_excerpter, only: :index
  after_action :handle_jsonp, only: :index

  def index
    request.format = 'json'
    @articles = ArticleDecorator.decorate_collection(Article.search(params[:q]).to_a)
    respond_with @articles, callback: params[:callback]
  end

  private

  def handle_jsonp
    response['Content-Type'] = 'application/javascript'
    response.body = "/**/#{params[:callback]}(#{response.body})"
  end

  def set_excerpter
    @excerpter = ThinkingSphinx::Excerpter.new(
      'article_core',
      params[:q],
      {
        before_match: '<span class="app_search_word">',
        after_match: '</span>'
      }
    )
  end

end
