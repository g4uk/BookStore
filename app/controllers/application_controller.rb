class ApplicationController < ActionController::Base
  before_action :set_locale, :set_categories, :set_cart

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
    Rails.application.routes.default_url_options[:locale]= I18n.locale
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
    @categories_for_menu = Category.all.includes(:books).order(:name)
  end
end
