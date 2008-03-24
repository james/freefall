class Comment < ActiveRecord::Base

  belongs_to :item, :polymorphic => true
  
    
  def is_spam?(request)
    @akismet = Akismet.new('3df7f7fa5e4a', 'http://abscond.org')
    return false unless @akismet.verifyAPIKey 
  
    # will return false, when everthing is ok and true when Akismet thinks the comment is spam. 
    return @akismet.commentCheck(request.remote_ip, request.user_agent, request.env['HTTP_REFERER'], '', 'comment', name, email, url, content, {})
  end
end
