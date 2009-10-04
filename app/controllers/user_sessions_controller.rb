class UserSessionsController < ApplicationController
  skip_before_filter :authenticate, :only => [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t('user_sessions.create.success')
      redirect_to user_path(current_user)
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = t('user_sessions.destroy.success')
    redirect_to root_url
  end
end
