require 'test_helper'

class InvoiceBarTest < ActiveSupport::TestCase
  test "InvoiceBar is loaded as a module" do
    assert_kind_of Module, InvoiceBar
  end
end