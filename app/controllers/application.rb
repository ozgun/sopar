# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '492887c0491b35047dc6c4b1ea64c24c'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  before_filter :login_from_cookie, :site_option
  
  #replaces the value to all keys matching words with "[FILTERED]"
  filter_parameter_logging :password, :new_password

  def login_from_cookie
    if cookies[:auth_token] && session[:user_id].nil?
      user = User.find_by_remember_token(cookies[:auth_token])
      if user && user.deactivated == 0 && user.update_last_logged_in_at && !user.remember_token_expires_at.nil? && Time.now < user.remember_token_expires_at 
        user.update_last_logged_in_at
        set_session_values(user)
        set_cookie_values(user)
        redirect_to admin_user_url(user)
      end
    else
      return
    end
  end
  
  def site_option
    @site_options = SitePref.find :first 
    @categories = Category.find :all, :order => "position"
    @latest_articles = Article.latest_articles
    @tags = Article.tag_counts
  end

  def log_exception(e)
      logger.error("***ERROR!***: Class: #{e.class}. Exception: #{e.exception}. \nBacktrace: ") 
      logger.error(e.backtrace.join("\n"))
  end

  protected

  def set_cookie_values(user)
    cookies[:auth_token] = { :value => user.remember_token, 
                             :expires => user.remember_token_expires_at }
  end

  def set_session_values(user)
    session[:user_id] = user.id
  end

  def reset_session_values
    session[:user_id] = nil
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find(:first, :conditions => ["id=? AND deactivated=0", session[:user_id]])
    else
      return false
    end
  end

  def login_required
    redirect_to "/" unless current_user
  end

  def upload_file(file_obj, upload_dir, filename)
    upload_dir = File.join("public", "images") if upload_dir.blank?
    filename_with_path = File.join(upload_dir, filename)
    File.open(filename_with_path, "wb") { |f| f.write(file_obj.read) }
  rescue Exception => e
    raise e
  end

  def delete_file(filename_with_full_path)
    File.delete(filename_with_full_path) if File.exists?(filename_with_full_path)
  rescue Exception => e
    raise e
  end

end
