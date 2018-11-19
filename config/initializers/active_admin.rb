# frozen_string_literal: true

ActiveAdmin.setup do |config|
  config.site_title = 'Bookstore'
  config.authorization_adapter = ActiveAdminAdapter
  config.on_unauthorized_access = :access_denied
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.root_to = 'books#index'
  config.comments = false
  config.comments_menu = false
  config.batch_actions = true
  config.localize_format = :short
  config.default_per_page = 15
  config.footer = "Bookstore for RG #{Time.current.year}"
end
