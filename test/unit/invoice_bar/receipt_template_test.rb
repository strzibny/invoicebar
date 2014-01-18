# encoding: utf-8

require 'test_helper'

class InvoiceBar::ReceiptTemplateTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :contact_name
  should allow_mass_assignment_of :contact_ic
  should allow_mass_assignment_of :contact_dic
  should allow_mass_assignment_of :name
  should allow_mass_assignment_of :amount
  should allow_mass_assignment_of :issue_date
  should allow_mass_assignment_of :account_id
  should allow_mass_assignment_of :user_id
  should allow_mass_assignment_of :address
  should allow_mass_assignment_of :address_attributes
  should allow_mass_assignment_of :items_attributes
  should validate_presence_of :name
  should accept_nested_attributes_for :address
  should accept_nested_attributes_for :items
  should have_one(:address).dependent(:destroy)
  should have_many(:items).dependent(:destroy)

  test "receipt template should validate uniqueness of name" do
    user = FactoryGirl.create(:invoice_bar_user)
    receipt_template = FactoryGirl.create(:invoice_bar_receipt_template, name: 'name', user: user)
    new_receipt_template = FactoryGirl.build(:invoice_bar_receipt_template, name: 'name', user: user)

    assert_equal false, new_receipt_template.valid?

    new_receipt_template = FactoryGirl.build(:invoice_bar_receipt_template, user: user)

    assert_equal true, new_receipt_template.valid?
  end
end
