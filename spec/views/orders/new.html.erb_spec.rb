require 'rails_helper'

RSpec.describe "orders/new", type: :view do
  before(:each) do
    assign(:order, Order.new(
      :user => nil,
      :delivery => nil,
      :credit_card => nil,
      :coupon => nil,
      :status => "MyString"
    ))
  end

  it "renders new order form" do
    render

    assert_select "form[action=?][method=?]", orders_path, "post" do

      assert_select "input[name=?]", "order[user_id]"

      assert_select "input[name=?]", "order[delivery_id]"

      assert_select "input[name=?]", "order[credit_card_id]"

      assert_select "input[name=?]", "order[coupon_id]"

      assert_select "input[name=?]", "order[status]"
    end
  end
end
