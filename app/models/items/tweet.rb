class Tweet < Item
  
  #This chunk ignores the SQL default so that it can use a more intelligent ruby default
  before_save :set_auto_publish
  def after_initialize
    self.published = nil if self.new_record?
  end
  def set_auto_publish
    if self.published == nil
      self.published = (text[-1] == 46)
    end
    true
  end
  
  def short_text
    self.text
  end
  
  def external_url
    'http://twitter.com/abscond/statuses/' + external_id
  end
  
  def self.fetch_data
    user = 'abscond'
    xml = Net::HTTP.start('twitter.com') do |http|
      req = Net::HTTP::Get.new('/statuses/user_timeline/' + user + '.xml')
      http.request(req).body
    end

    REXML::Document.new(xml).elements.each('//status') do |status|
      tweet = Tweet.find_by_external_id(status.elements["id"].text) || new()
      tweet.external_id = status.elements["id"].text
      tweet.created_at = status.elements["created_at"].text
      tweet.text = status.elements["text"].text
      tweet.save
    end
  end
end
