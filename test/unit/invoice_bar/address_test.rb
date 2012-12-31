# encoding: utf-8

require 'test_helper'

class InvoiceBar::AddressTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :city
  should allow_mass_assignment_of :city_part
  should allow_mass_assignment_of :street
  should allow_mass_assignment_of :street_number
  should allow_mass_assignment_of :postcode
  should allow_mass_assignment_of :extra_address_line 
  should validate_presence_of :city
  should validate_presence_of :street
  should validate_presence_of :street_number
  should validate_presence_of :postcode
  should belong_to :addressable 
  should allow_mass_assignment_of :addressable_id
  should allow_mass_assignment_of :addressable_type
  
  test "address should create a copy of self" do
    address = FactoryGirl.build(:invoice_bar_address)   
    copy = address.copy
    
    assert_equal address.street, copy.street
    assert_equal address.street_number, copy.street_number
    assert_equal address.city, copy.city
    assert_equal address.city_part, copy.city_part
    assert_equal address.postcode, copy.postcode
    assert_equal address.extra_address_line, copy.extra_address_line
  end
end