# frozen_string_literal: true

class FillAddressesService
  def initialize(order:, order_params:)
    @order = order
    @order_params = order_params
    @billing_flag = order_params[:billing_flag].eql?('1')
    @billing_country_code = order_params[:billing_address_attributes][:country]
    @shipping_country_code = order_params[:shipping_address_attributes][:country]
  end

  def call
    country_decoding
    @order.assign_attributes(@order_params)
    assign_shipping_address
    @order.fill_address! if @order.may_fill_address? && @order.save
  end

  private

  def assign_shipping_address
    @order.shipping_address.assign_attributes(@order_params[:billing_address_attributes]) if @billing_flag
  end

  def country_name(country_code)
    ISO3166::Country[country_code].name
  end

  def country_decoding
    @order_params[:billing_address_attributes][:country] = country_name(@billing_country_code)
    @order_params[:shipping_address_attributes][:country] = country_name(@shipping_country_code)
  end
end
