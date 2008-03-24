# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def url_for_item(item)
    case item.class.to_s
    when "Tweet"
      return item.external_url
    when "Article"
      return article_url(item)
    else
      return "http://abscond.org/"
    end
  end
  
  def url_for_item_comments(item)
    url_for_item(item) + '/comments'
  end
  
  def url_for_item_comments_preview(item)
    url_for_item_comments(item) + '/preview'
  end
  
  def markdown(string)
    return '' if string.blank?
    returning html = BlueCloth.new(string).to_html do
      require 'hpricot'
      Hpricot(html).search("//p").each do |p|
        html.sub!(p.to_s, p.to_s.gsub(%r{\n+}, "\n<br/>\n"))
      end
    end
  end
end
