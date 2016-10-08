class ArticleDecorator < Draper::Decorator
  delegate_all

  URLS = { 'text' => 'texts', 'persona' => 'personalii', 'thesaurus' => 'glossariy' }
  BASE_URL = 'http://app.papush.ru/'

  def url
    BASE_URL + URLS[(object.article_type || 'text')] + '/' + (object.url || '')
  end

  def article_type
    case object.article_type
      when 'persona' then
        'Персоналии'
      when 'thesaurus' then
        'Глоссарий'
      when 'text' then
        'Тексты'
    end
  end

  def parent_link
    object.article_type == 'persona' ? 'personas.html' : 'thesaurus.html'
  end

  def excerpts
    hit = context.find {|h| h['_id'] == object.id.to_s}
    ['', hit['highlight']['content.analyzed'], ''].join(' &#8230; ').html_safe
  end

end
