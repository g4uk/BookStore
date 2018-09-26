class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Facebook') if is_navigational_format?
      ApplicationMailer.welcome_email(@user, @user.password).deliver
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      redirect_to signup_users_url
    end
  end

  def failure
    redirect_to login_users_url
  end
end
