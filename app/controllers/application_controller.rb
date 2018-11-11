# frozen_string_literal: true

class ApplicationController < ActionController::Base
  layout 'main'

  before_action :locale, :cart

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def cart
    @cart = ::Cart.find(session[:cart_id]).decorate
  rescue ActiveRecord::RecordNotFound
    @cart = ::Cart.create.decorate
    session[:cart_id] = @cart.id
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
      redirect_to login_users_path, notice: I18n.t(:sign_in)
    end
  end
end
