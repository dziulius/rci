# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  helper_method :current_user_session, :current_user

  before_filter :authenticate, :set_locale

  private

  def set_locale
    lang = params[:lang] || session[:lang] || I18n.default_locale
    I18n.locale = session[:lang] = lang
  end

  def authenticate
    unless current_user
      flash[:error] = t('common.not_authenticated')
      redirect_to login_path
    else
      Authorization.current_user = current_user
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def render_tabs(*tabs)
    respond_to do |format|
      format.html
      format.js &render_js_tabs(*tabs)
    end
  end

  def render_js_tabs(*tabs)
    @tabs = tabs
    Proc.new { render :partial => (tabs.detect {|tab| tab.to_s == params[:tab] } || tabs.first).to_s }
  end
end
