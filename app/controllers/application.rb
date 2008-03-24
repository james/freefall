# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  
  # Pick a unique cookie name to distinguish our session data from others'
  
  session :session_key => '_freefall_session_id'
  
  before_filter :dev_mode
  before_filter :set_current_user
  
  def dev_mode
    if RAILS_ENV == "development"
      session[:openid_url] = 'http://abscond.org'
    end
  end
  
  def set_current_user
    User.current_user = User.find_or_make(session[:openid_url])
    return true
  end
  
  def is_admin?
    User.current_user && User.current_user.admin?
  end
  
  def check_admin
    if User.current_user
      if User.current_user.admin?
        return true
      else
        return access_denied
      end
    else
      redirect_to new_session_path
    end
  end
  
  def access_denied
    render :text => 'Access Denied for ' + session[:openid_url]
  end
  
  def rescue_404
    render :text => 'FAIL'
  end
  
  def url_for_item(item, action='')
    case item.class.to_s
    when "Tweet"
      url = tweet_url(item)
    when "Article"
      url = article_url(item)
    else
      url = "http://abscond.org"
    end
    unless action.blank?
      url += ";#{action}"
    end
    url
  end
end
