class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def welcome_email(user, generated_password)
    @user = user
    @password = generated_password
    mail(to: @user.email, subject: 'Welcome to Bookstore!')
  end

  def order_email(email, order_id)
    @order_id = order_id
    @email = email
    mail(to: email, subject: 'Thank you for the order!')
  end
end
