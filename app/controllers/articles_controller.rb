class ArticlesController < ApplicationController
  respond_to :json

  before_action :set_excerpter, only: :index

  def index
    @articles = ArticleDecorator.decorate_collection(Article.search(params[:q]).to_a)
    respond_with @articles, callback: params[:callback]
  end

  private

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
