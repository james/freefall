class Article < Item
  before_save :set_short_text
  
  def set_short_text
    self.short_text = truncate(self.text) if self.short_text.blank?
  end
  
  def truncate(text, length = 30, end_string = ' …')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end
