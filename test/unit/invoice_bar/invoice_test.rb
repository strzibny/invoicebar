# encoding: utf-8

require 'test_helper'

class InvoiceBar::InvoiceTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :contact_name
  should allow_mass_assignment_of :contact_ic
  should allow_mass_assignment_of :contact_dic
  should allow_mass_assignment_of :number
  should allow_mass_assignment_of :payment_identification_number
  should allow_mass_assignment_of :amount
  should allow_mass_assignment_of :issue_date
  should allow_mass_assignment_of :due_date
  should allow_mass_assignment_of :sent
  should allow_mass_assignment_of :paid
  should allow_mass_assignment_of :account_id
  should allow_mass_assignment_of :user_id
  should allow_mass_assignment_of :address
  should allow_mass_assignment_of :address_attributes
  should allow_mass_assignment_of :items_attributes  
  should accept_nested_attributes_for :address
  should accept_nested_attributes_for :items
  should have_one(:address).dependent(:destroy)
  should have_many(:items).dependent(:destroy)
  
  test "invoice should validate uniqueness of number" do
    user = FactoryGirl.create(:invoice_bar_user)   
    invoice = FactoryGirl.create(:invoice_bar_invoice, number: '2', user: user)   
    new_invoice = FactoryGirl.build(:invoice_bar_invoice, number: '2', user: user)
    
    assert_equal false, new_invoice.valid?

    new_invoice = FactoryGirl.build(:invoice_bar_invoice, user: user)
    
    assert_equal true, new_invoice.valid?
  end

  test "invoice should be marked as paid" do
    invoice = FactoryGirl.create(:invoice_bar_invoice)
    invoice.mark_as_paid
    
    assert_equal true, invoice.paid
  end
  
  test "invoice should be marked as sent" do
    invoice = FactoryGirl.create(:invoice_bar_invoice)
    invoice.mark_as_sent
    
    assert_equal true, invoice.sent
  end
  
  test "invoice should apply template" do
    invoice_template = FactoryGirl.build(:invoice_bar_filled_invoice_template)  
    orig_invoice = FactoryGirl.build(:invoice_bar_incomplete_invoice) 
    invoice = FactoryGirl.build(:invoice_bar_incomplete_invoice) 
    invoice.apply_template(invoice_template)

    assert_equal orig_invoice.contact_name, invoice.contact_name
    assert_equal orig_invoice.contact_ic, invoice.contact_ic
    assert_equal Date.yesterday, invoice.issue_date
    assert_not_equal invoice_template.contact_dic, invoice.contact_dic
    assert_not_equal orig_invoice.issue_date, invoice.issue_date
    assert_not_equal orig_invoice.due_date, invoice.due_date
    assert_equal orig_invoice.address_city, invoice.address_city
    assert_equal orig_invoice.address_street, invoice.address_street
  end
end