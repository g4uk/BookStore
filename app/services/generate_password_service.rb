class GeneratePasswordService
  class << self
    def call
      Devise.friendly_token.first(8) + rand(10).to_s
    end
  end
end
