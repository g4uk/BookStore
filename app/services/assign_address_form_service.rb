class AssignAddressFormService
  def initialize(user, type)
    @address = user.send(type)
    @type = type
    @user = user
  end

  def call
    @address ? address_form : AddressForm.new(type: address_class_name)
  end

  private

  def address_form
    AddressForm.new(first_name: @address.first_name, last_name: @address.last_name, 
                    address: @address.address, country: @address.country, city: @address.city,
                    zip: @address.zip, phone: @address.phone, addressable_id: @user.id, type: address_class_name)
  end

  def address_class_name
    @type.to_s.split('_').first
  end
end
