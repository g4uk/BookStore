module UsersSettings
  extend ActiveSupport::Concern

  included do
    after_create :assign_default_role
  end

  def assign_default_role
    add_role(:customer) if roles.blank?
  end

  class_methods do
    def find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if (email = conditions.delete(:email)).present?
        where(email: email.downcase).first
      elsif conditions.key?(:reset_password_token)
        where(reset_password_token: conditions[:reset_password_token]).first
      end
    end

    def from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token(10) + rand(10).to_s
        user.name = auth.info.name
        user.image = auth.info.image
      end
    end
  end
end
