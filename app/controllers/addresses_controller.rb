# frozen_string_literal: true

class AddressesController < ApplicationController
  load_and_authorize_resource

  before_action :authenticate_user!

  respond_to :js

  def create
    instance_variable_set("@#{address_form_params[:type]}_form".to_sym, AddressForm.new(address_form_params))
    @updated_address = instance_variable_get("@#{address_form_params[:type]}_form")
    return render :update_addresses if @updated_address.save
    render :edit_addresses
  end

  private

  def address_form_params
    params.require(:address_form).permit(%i[first_name last_name address city zip country phone type addressable_id])
  end
end
