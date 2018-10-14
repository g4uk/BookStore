class QuickRegistrationService < Rectify::Command
  def initialize(params)
    @email = params[:email]
    @password = Devise.friendly_token(10) + rand(10).to_s
    @user = User.where(email: @email)
  end

  def call
    register
    @user
  end

  private

  def register
    @user = User.create(email: @email, password: @password)
    ApplicationMailer.welcome_email(@user, @password).deliver if @user.errors.empty?
  end
end
