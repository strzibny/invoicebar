# encoding: utf-8

require 'test_helper'

class InvoiceBar::AccountTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :name
  should allow_mass_assignment_of :bank_account_number
  should allow_mass_assignment_of :iban
  should allow_mass_assignment_of :swift
  should allow_mass_assignment_of :amount  
  should validate_presence_of :name
  should validate_presence_of :amount
  should validate_presence_of :user_id
  should validate_presence_of :currency_id 
  should ensure_length_of(:iban).is_at_least(15).is_at_most(34)
  should ensure_length_of(:swift).is_at_least(8).is_at_most(11)
  should belong_to :currency
  should belong_to :user

  test "account should validate uniqueness of name" do
    user = FactoryGirl.create(:invoice_bar_user)   
    account = FactoryGirl.create(:invoice_bar_account, name: 'name', user: user)   
    new_account = FactoryGirl.build(:invoice_bar_account, name: 'name', user: user)
    
    assert_equal false, new_account.valid?

    new_account = FactoryGirl.build(:invoice_bar_account, user: user)
    
    assert_equal true, new_account.valid?
  end
end