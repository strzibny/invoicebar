require 'invoice_printer'

module InvoiceBar
  class ReceiptPDF
    include ActionView::Helpers::TranslationHelper

    def initialize(receipt)
      @receipt = receipt
    end

    def render
      InvoicePrinter.render(
        document: printable_receipt,
        font: File.expand_path('app/assets/fonts/invoice_bar/Overpass_Regular.ttf', InvoiceBar::Engine.root)
      )
    end

    private

    def printable_receipt
      InvoicePrinter::Document.new(
        number: @receipt.number.to_s,
        provider_name: @receipt.user_name.to_s,
        provider_ic: @receipt.user_tax_id.to_s,
        provider_street: @receipt.user_street.to_s,
        provider_street_number: @receipt.user_street_number.to_s,
        provider_postcode: @receipt.user_postcode.to_s,
        provider_city: @receipt.user_city.to_s,
        provider_city_part: @receipt.user_city_part.to_s,
        provider_extra_address_line: @receipt.user_extra_address_line.to_s,
        purchaser_name: @receipt.contact_name.to_s,
        purchaser_ic: @receipt.contact_tax_id.to_s,
        purchaser_dic: @receipt.contact_tax_id2.to_s,
        purchaser_street: @receipt.address_street.to_s,
        purchaser_street_number: @receipt.address_street_number.to_s,
        purchaser_postcode: @receipt.address_postcode.to_s,
        purchaser_city: @receipt.address_city.to_s,
        purchaser_city_part: @receipt.address_city_part.to_s,
        purchaser_extra_address_line: @receipt.address_extra_address_line.to_s,
        issue_date: l(@receipt.issue_date, format: :invoice).to_s,
        total: @receipt.amount.to_s,
        bank_account_number: @receipt.account_bank_account_number.to_s,
        account_iban: @receipt.account_iban.to_s,
        account_swift: @receipt.account_swift.to_s,
        items: printable_items,
        note: @receipt.note
      )
    end

    def printable_items
      printable_items = []
      @receipt.items.each do |item|
        printable_items << InvoicePrinter::Document::Item.new(
          name: item.name.to_s,
          quantity: item.number.to_s,
          unit: item.unit.to_s,
          price: item.price.to_s,
          amount: item.amount.to_s
        )
      end
      printable_items
    end
  end
end
