class ArticlesController < ApplicationController
  respond_to :json

  after_action :handle_jsonp, only: :index

  ELASTICSEARCH_OPTIONS = {highlight: {pre_tags: ['<span class="app_search_word">'], post_tags: ['</span>'], fields: {'content.analyzed' => {fragment_size: 80}}}}

  def index
    request.format = 'json'
    search_results = Article.search(params[:q], body_options: ELASTICSEARCH_OPTIONS)
    @articles = ArticleDecorator.decorate_collection(search_results.to_a, context: search_results.hits)
    respond_with @articles, callback: params[:callback]
  end

  private

  def handle_jsonp
    response['Content-Type'] = 'application/javascript'
    response.body = "/**/#{params[:callback]}(#{response.body})"
  end

end
