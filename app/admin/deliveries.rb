# frozen_string_literal: true

ActiveAdmin.register Delivery do
  permit_params :name, :duration, :price
end
