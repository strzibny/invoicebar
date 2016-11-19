require 'test_helper'
require 'invoice_bar/sequence'

class SequenceTest < ActiveSupport::TestCase
  setup do
    travel_to Time.new(2016, 10, 02, 12, 00, 00)
  end

  teardown do
    travel_back
  end

  test "sequence returns correct numbers for format VFYYYYMMDD increased by month" do
    sequence = InvoiceBar::Sequence.new(
      from: 'VF201610020001',
      format: ['VF', :year, :month, :day]
    )

    assert_equal 'VF201610020002', sequence.nextn(by: :month)
  end

  test "sequence returns correct numbers for format VFYYYYMMDD increased by day" do
    sequence = InvoiceBar::Sequence.new(
      from: 'VF201610020001',
      format: ['VF', :year, :month, :day]
    )

    assert_equal 'VF201610020002', sequence.nextn(by: :day)
  end

  test "sequence returns correct numbers for format DFYYMM increased by day" do
    sequence = InvoiceBar::Sequence.new(
      from: 'DF16100109',
      format: ['DF', :y, :month, :day]
    )

    assert_equal 'DF16100201', sequence.nextn(by: :day)
  end

  test "sequence returns correct numbers for format DFYYMM increased by month" do
    sequence = InvoiceBar::Sequence.new(
      from: 'DF16100109',
      format: ['DF', :y, :month, :day]
    )

    assert_equal 'DF16100210', sequence.nextn(by: :month)
  end
end
