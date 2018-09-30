class ApplicationController < ActionController::Base
  before_action :set_locale, :set_categories, :set_cart

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale] = I18n.locale
  end

  def set_cart
    @cart = ::Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = ::Cart.create
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
      flash[:notice] = 'You need to sign in or sign up before continuing.'
      redirect_to login_users_url
    end
  end

  def set_categories
    @categories = Category.all.order(:name)
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end
end
