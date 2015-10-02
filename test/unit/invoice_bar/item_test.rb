require 'test_helper'

class InvoiceBar::ItemTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :name
  should allow_mass_assignment_of :number
  should allow_mass_assignment_of :price
  should allow_mass_assignment_of :unit
  should_not allow_mass_assignment_of :amount
  should validate_presence_of :name
  should belong_to :itemable
  should allow_mass_assignment_of :itemable_id
  should allow_mass_assignment_of :itemable_type

  test "item should create a copy of self" do
    item = FactoryGirl.build(:invoice_bar_item)
    copy = item.copy

    assert_equal item.name, copy.name
    assert_equal item.number, copy.number
    assert_equal item.price, copy.price
    assert_equal item.unit, copy.unit
    assert_equal item.amount, copy.amount
  end

  test "should count total amount for item" do
    item = FactoryGirl.build(:invoice_bar_item, name: 'Item', price: 100, number: 5)

    item.update_amount

    assert_equal 500, item.amount

    item.price = 100
    item.number = 10

    assert_equal 1000, item.total
  end

  test "should show human price " do
    item = FactoryGirl.build(:invoice_bar_item, name: 'Item', price: 100, number: 5)

    item.update_amount

    assert_equal FormattedMoney.amount(100), item.human_price
    assert_equal FormattedMoney.amount(500), item.human_amount
  end
end
