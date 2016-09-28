require 'test_helper'

class CurrencyTest < ActiveSupport::TestCase
  should allow_mass_assignment_of :name
  should allow_mass_assignment_of :symbol
  should allow_mass_assignment_of :priority
  should validate_presence_of :name
  should validate_presence_of :symbol
  should validate_presence_of :priority
  should validate_length_of(:symbol).is_at_most(3)
end
