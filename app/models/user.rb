class User < ActiveRecord::Base
  cattr_accessor :current_user
  attr_protected :permission

  def self.find_or_make(openidurl)
    return false unless openidurl
    if u = find_by_openid_url(openidurl)
      return u
    else
      new(:openid_url => openidurl)
    end
  end
  
  def admin?
    permission == 'admin'
  end
  
  def self.is_admin?
    User.current_user && User.current_user.admin?
  end
end