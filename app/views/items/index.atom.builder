xml.instruct!

xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do

  xml.title   "Abscond.org"
  xml.link    "rel" => "self", "href" => "http://feeds.feedburner.com/abscond/personal"
  xml.link    "rel" => "alternate", "href" => "http://abscond.org"
  xml.id      "href" => "http://abscond.org"
  xml.updated @items.first.created_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @items.any?
  xml.author  { xml.name "James Darling" }

  @items.each do |item|
    xml.entry do
      xml.title   item.title
      xml.link    "rel" => "alternate", "href" => url_for_item(item)
      xml.id      url_for_item(item)
      xml.updated item.created_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  { xml.name 'James Darling' }
      xml.summary item.short_text
      xml.content "type" => "html" do
        xml.text! item.text
      end
    end
  end

end
