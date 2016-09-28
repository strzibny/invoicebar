require 'test_helper'

class InvoiceBarHelperTest < ActionView::TestCase
  include InvoiceBarHelper

  test "should define active state for controller" do
    params[:controller] = 'invoice_bar/invoices'

    assert_equal 'active', active_for_controller('invoices')
    assert_not_equal 'active', active_for_controller('receipts')
  end

  test "should format postcode" do
    assert_equal '747 27', formatted_postcode('74727')
    assert_equal '747 35', formatted_postcode('74735')
  end
end
