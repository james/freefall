# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def url_for_item(item, action='')
    controller.url_for_item(item, action)
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
