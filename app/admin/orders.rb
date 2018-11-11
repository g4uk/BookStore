# frozen_string_literal: true

ActiveAdmin.register Order do
  STATUSES = %i[in_delivery delivered canceled].freeze

  menu priority: 4

  filter :created_at

  scope('In Progress') { |order| order.where(status: %i[in_progress in_queue in_delivery]) }
  scope('Delivered') { |order| order.where(status: :delivered) }
  scope('Canceled') { |order| order.where(status: :canceled) }

  permit_params :status

  config.clear_action_items!

  index do
    render 'index', context: self
  end

  member_action :view, method: :get do
    @order = OrderDecorator.decorate(Order.find(params[:id]))
    @order.shipping_address = @order.shipping_address.decorate if @order.shipping_address
    @order.billing_address = @order.billing_address.decorate if @order.billing_address
    respond_to do |format|
      format.js
    end
  end

  controller do
    before_action :set_order, only: %i[show edit update]

    def edit
      @statuses = STATUSES
      respond_to do |format|
        format.js
      end
    end

    def update
      respond_to do |format|
        @errors = @order.errors.full_messages.join(', ') unless @order.update(permitted_params)
        format.js
      end
    end

    def set_order
      @order = Order.find(params[:id])
    end

    def permitted_params
      params.permit(:status)
    end
  end
end
