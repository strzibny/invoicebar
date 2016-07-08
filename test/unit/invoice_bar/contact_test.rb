require 'test_helper'

class InvoiceBar::ContactTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :tax_id
  should allow_mass_assignment_of :tax_id2
  should allow_mass_assignment_of :bank_account
  should allow_mass_assignment_of :email
  should allow_mass_assignment_of :phone
  should allow_mass_assignment_of :web
  should accept_nested_attributes_for :address
  should validate_presence_of :name
  should validate_presence_of :user_id
  should validate_length_of(:tax_id2).is_at_least(4).is_at_most(14)
  should belong_to :user
end
