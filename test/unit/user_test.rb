require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :name
  should allow_mass_assignment_of :tax_id
  should allow_mass_assignment_of :email
  should allow_mass_assignment_of :phone
  should allow_mass_assignment_of :web
  should allow_mass_assignment_of :password
  should allow_mass_assignment_of :crypted_password
  should allow_mass_assignment_of :salt
  should allow_mass_assignment_of :remember_me_token
  should allow_mass_assignment_of :remember_me_token_expires_at
  should allow_mass_assignment_of :reset_password_email_sent_at
  should allow_mass_assignment_of :reset_password_token
  should allow_mass_assignment_of :reset_password_token_expires_at
  should allow_mass_assignment_of :address_attributes
  should validate_presence_of :name
  should validate_presence_of :tax_id
  should validate_presence_of :email
  should accept_nested_attributes_for :address
  should have_one(:address).dependent(:destroy)
  should have_many(:accounts).dependent(:destroy)
  should have_many(:contacts).dependent(:destroy)
  should have_many(:invoices).dependent(:destroy)
  should have_many(:invoice_templates).dependent(:destroy)
end
