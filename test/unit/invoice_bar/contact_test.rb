# encoding: utf-8

require 'test_helper'

class InvoiceBar::ContactTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :ic
  should allow_mass_assignment_of :dic
  should allow_mass_assignment_of :bank_account
  should allow_mass_assignment_of :email
  should allow_mass_assignment_of :phone
  should allow_mass_assignment_of :web
  should accept_nested_attributes_for :address
  should validate_presence_of :name
  should validate_presence_of :user_id
  should ensure_length_of(:dic).is_at_least(4).is_at_most(14)
  should belong_to :user
end