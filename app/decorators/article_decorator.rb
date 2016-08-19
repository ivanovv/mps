class ArticleDecorator < Draper::Decorator
  delegate_all

  URLS = {'text' => 'texts', 'persona' => 'personalii', 'thesaurus' => 'glossariy'}
  BASE_URL = 'http://app.papush.ru/'

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def url
    BASE_URL + URLS[(object.article_type || 'text')] + '/' + (object.url || '')
  end

  def article_type
    case object.article_type
      when 'persona' then
        "Персоналии"
      when 'thesaurus' then
        "Глоссарий"
      when 'text' then
        "Тексты"
    end
  end

end
