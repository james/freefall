class Session < ActiveRecord::Base
  def authenticate_with_open_id(identity_url, :required => [], :optional => :fullname) do |status, identity_url, registration|
    case status
    when :missing
      failed_login "Sorry, the OpenID server couldn't be found"
    when :canceled
      failed_login "OpenID verification was canceled"
    when :failed
      failed_login "Sorry, the OpenID verification failed"
    when :successful
      
    end
  end
end