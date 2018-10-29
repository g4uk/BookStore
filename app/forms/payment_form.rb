class PaymentForm
  include ActiveModel::Model
  include Virtus.model

  attr_accessor :owner_name, :expiration_date, :cvv

  attribute :id, Integer
  attribute :number

  validates :number, presence: true
  validates :number, format: { with: CREDIT_CARD_NUMBER }

  def save
    return false unless valid?
    CreditCard.create(number: number.last(4))
  end
end
