class AccountsController < ApplicationController
  before_filter :redirect_logged_in_user, :only => [ :index, :login ]
  layout nil

  #
  # Login form
  #
  def login
  end

  #
  # authenticate user 
  #
  def authenticate
    user = User.login(params[:user][:username], params[:user][:password])
    if user
      user.update_last_logged_in_at
      set_session_values(user)
      if params[:remember_me]
        user.remember_me
        set_cookie_values(user)
      else
        user.forget_me
        delete_cookies
      end
      #redirect_user(user)
      redirect_to admin_user_url(user)
    else
      #logger.debug("********************************************")
      flash[:warning] = "Error! Try again!"
      #render :action => :login
      redirect_to "/login"
    end
  end

  def logout
    delete_cookies
    reset_session_values
    #flash[:notice] = ""
    redirect_to "/"
  end

  protected

  def delete_cookies
    cookies.delete :auth_token
  end

  def redirect_logged_in_user
    redirect_to admin_user_url(session[:user_id]) if session[:user_id]
  end

end
