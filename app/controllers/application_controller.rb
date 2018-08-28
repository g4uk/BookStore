class ApplicationController < ActionController::Base

  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale]= I18n.locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def access_denied(exception)
    redirect_to root_path, alert: exception.message
  end

  def authenticate_user!(options = {})
    if user_signed_in?
      super(options)
    else
      flash[:notice] = 'You need to sign in or sign up before continuing.'
      redirect_to login_customer_users_url
    end
  end
end
