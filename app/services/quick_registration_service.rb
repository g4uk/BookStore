class QuickRegistrationService < Rectify::Command
  def initialize(params)
    @email = params[:email]
    @password = Devise.friendly_token(10) + rand(10).to_s
    @user = User.where(email: @email)
  end

  def call
    register
    if @user.errors.empty?
      send_email
      return broadcast(:ok, @user)
    else
      broadcast(:invalid, @user.errors.full_messages)
    end
  end

  private

  def register
    @user = User.create(email: @email, password: @password)
  end

  def send_email
    ApplicationMailer.welcome_email(@user, @password).deliver
  end
end
