# frozen_string_literal: true
class AddressForm
  include ActiveModel::Model
  include Virtus.model

  NAME = /\A[a-zA-Z\s]+\Z/
  ADDRESS = /\A[a-zA-Z0-9,\-\s]+\Z/
  ZIP = /\A[0-9-]{1,10}\Z/
  PHONE = /\A\+[0-9\s]{1,15}\Z/
  NAME_INPUT = '^[a-zA-Z\s]+$'
  PHONE_INPUT = '^\+[0-9\s]{1,15}$'
  ADDRESS_INPUT = '^[a-zA-Z0-9,\-\s]+$'
  ZIP_INPUT = '^[0-9-]{1,10}$'

  attr_accessor :first_name, :last_name, :address, :country, :city,
                :zip, :phone, :type, :addressable_id

  validates :first_name, :last_name, :address, :country, :city, :zip, :phone, presence: true
  validates :first_name, :last_name, :address, :country, :city, length: { maximum: 50 }
  validates :zip, length: { maximum: 10 }
  validates :phone, length: { maximum: 15 }
  validates :first_name, :last_name, :country, :city, format: { with: NAME }
  validates :address, format: { with: ADDRESS }
  validates :zip, format: { with: ZIP }
  validates :phone, format: { with: PHONE }

  def save
    return false unless valid?
    update
  end

  private

  def update
    @user = User.find(addressable_id)
    update_address(type)
  end

  def update_address(type)
    @user.send("build_#{type}_address".to_sym) unless @user.send("#{type}_address".to_sym)
    @user.send("#{type}_address".to_sym).update(first_name: first_name, last_name: last_name, address: address,
                                                country: country_name, city: city, zip: zip, phone: phone)
  end

  def country_name
    ISO3166::Country[country].name
  end
end
