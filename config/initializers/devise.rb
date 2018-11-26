# frozen_string_literal: true

Devise.setup do |config|
  config.omniauth :facebook, Rails.application.credentials.facebook_key,
                  Rails.application.credentials.facebook_secret,
                  callback_url: 'http://localhost:3000/users/auth/facebook/callback'
  config.mailer_sender = 'no-reply@bookstore.com'
  config.mailer = 'AuthMailer'

  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.send_email_changed_notification = false
  config.send_password_change_notification = false
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..70
  config.email_regexp = EMAIL_REGEXP
  config.reset_password_within = 6.hours
  config.scoped_views = true
  config.sign_out_via = :delete
  config.omniauth :facebook, Rails.application.credentials.facebook_key,
                  Rails.application.credentials.facebook_secret, scope: 'email',
                                                                 token_params: { parse: :json }, display: 'popup'
end
