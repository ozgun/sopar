class Admin::UsersController < ApplicationController
  layout "admin"
  before_filter :login_required

  def show
    @user = User.find(params[:id]) 
  end

  def edit
    @user = User.find(params[:id]) 
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
    redirect_to "/"
  end

  def update
    @user = User.find(params[:id]) 
    @user.update_attributes!(params[:user])
    flash[:notice] = "User profile updated."
    redirect_to edit_admin_user_url(@user)
  rescue ActiveRecord::RecordInvalid => e
    flash[:warning] = COMMON_ERROR_MSG
    render :action =>  :edit, :id => @user
  rescue Exception => e
    flash[:warning] = e.message
    log_exception(e)
    render :action =>  :edit, :id => @user
  end

  def update_password
    @user = User.find(params[:id])
    if @user.update_password(params[:user][:new_password],params[:user][:password_confirmation])
      flash[:notice] = "Password updated."
      redirect_to edit_admin_user_url(@user)
    else
      flash[:warning] = COMMON_ERROR_MSG
      render :action => "edit", :id => @user.id
    end
  end

end
