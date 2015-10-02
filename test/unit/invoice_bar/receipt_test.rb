require 'test_helper'

class InvoiceBar::ReceiptTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :contact_name
  should allow_mass_assignment_of :contact_ic
  should allow_mass_assignment_of :contact_dic
  should allow_mass_assignment_of :number
  should allow_mass_assignment_of :amount
  should allow_mass_assignment_of :issue_date
  should allow_mass_assignment_of :account_id
  should allow_mass_assignment_of :user_id
  should allow_mass_assignment_of :address
  should allow_mass_assignment_of :address_attributes
  should allow_mass_assignment_of :items_attributes
  should accept_nested_attributes_for :address
  should accept_nested_attributes_for :items
  should have_one(:address).dependent(:destroy)
  should have_many(:items).dependent(:destroy)

  test "receipt should validate uniqueness of number" do
    user = FactoryGirl.create(:invoice_bar_user)
    receipt = FactoryGirl.create(:invoice_bar_receipt, number: '2', user: user)
    new_receipt = FactoryGirl.build(:invoice_bar_receipt, number: '2', user: user)

    assert_equal false, new_receipt.valid?

    new_receipt = FactoryGirl.build(:invoice_bar_receipt, user: user)

    assert_equal true, new_receipt.valid?
  end

  test "receipt should apply template" do
    receipt_template = FactoryGirl.build(:invoice_bar_filled_receipt_template)
    orig_receipt = FactoryGirl.build(:invoice_bar_incomplete_receipt)
    receipt = FactoryGirl.build(:invoice_bar_incomplete_receipt)
    receipt.apply_template(receipt_template)

    assert_equal orig_receipt.contact_name, receipt.contact_name
    assert_equal orig_receipt.contact_ic, receipt.contact_ic
    assert_equal Date.yesterday, receipt.issue_date
    assert_not_equal receipt_template.contact_dic, receipt.contact_dic
    assert_not_equal orig_receipt.issue_date, receipt.issue_date
    assert_equal orig_receipt.address_city, receipt.address_city
    assert_equal orig_receipt.address_street, receipt.address_street
  end
end
