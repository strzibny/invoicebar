require 'invoice_printer'

class InvoicePDF
  include ActionView::Helpers::TranslationHelper
  include InvoiceBarHelper

  def initialize(invoice)
    @invoice = invoice
  end

  def render
    labels = @invoice.deposit? ? { name: 'Zálohová faktura' } : {}

    InvoicePrinter.render(
      document: printable_invoice,
      labels: labels,
      font: File.expand_path('app/assets/fonts/invoice_bar/Overpass_Regular.ttf', InvoiceBar::Application.root)
    )
  end

  private

  def printable_invoice
    InvoicePrinter::Document.new(
      number: @invoice.number.to_s,
      provider_name: @invoice.user_name.to_s,
      provider_tax_id: @invoice.user_tax_id.to_s,
      provider_street: @invoice.user_street.to_s,
      provider_street_number: @invoice.user_street_number.to_s,
      provider_postcode: @invoice.user_postcode.to_s,
      provider_city: @invoice.user_city.to_s,
      provider_city_part: @invoice.user_city_part.to_s,
      provider_extra_address_line: @invoice.user_extra_address_line.to_s,
      purchaser_name: @invoice.contact_name.to_s,
      # for invoice_printer 0.0.8 this is reversed.
      purchaser_tax_id: @invoice.contact_tax_id.to_s,
      purchaser_tax_id2: @invoice.contact_tax_id2.to_s,
      purchaser_street: @invoice.address_street.to_s,
      purchaser_street_number: @invoice.address_street_number.to_s,
      purchaser_postcode: @invoice.address_postcode.to_s,
      purchaser_city: @invoice.address_city.to_s,
      purchaser_city_part: @invoice.address_city_part.to_s,
      purchaser_extra_address_line: @invoice.address_extra_address_line.to_s,
      issue_date: l(@invoice.issue_date, format: :invoice).to_s,
      due_date: l(@invoice.due_date, format: :invoice).to_s,
      total: formatted_amount(@invoice.amount, @invoice.try(:account).try(:currency_symbol)),
      bank_account_number: @invoice.account_bank_account_number.to_s,
      account_iban: @invoice.account_iban.to_s,
      account_swift: @invoice.account_swift.to_s,
      items: printable_items,
      note: @invoice.note
    )
  end

  def printable_items
    printable_items = []
    @invoice.items.each do |item|
      printable_items << InvoicePrinter::Document::Item.new(
        name: item.name.to_s,
        quantity: item.number.to_s,
        unit: item.unit.to_s,
        price: formatted_amount(item.price),
        amount: formatted_amount(item.amount)
      )
    end
    printable_items
  end
end
