require 'invoice_printer'

module InvoiceBar
  class ReceiptPDF
    def initialize(receipt)
      @receipt = receipt
    end

    def render
      InvoicePrinter.render(document: printable_receipt)
    end

    private

    def printable_receipt
      InvoicePrinter::Document.new(
        number: @receipt.number,
        provider_name: @receipt.user_name,
        provider_ic: @receipt.user_ic,
        provider_street: @receipt.user_street,
        provider_street_number: @receipt.user_street_number,
        provider_postcode: @receipt.user_postcode,
        provider_city: @receipt.user_city,
        provider_city_part: @receipt.user_city_part,
        provider_extra_address_line: @receipt.user_extra_address_line,
        purchaser_name: @receipt.contact_name,
        purchaser_ic: @receipt.contact_ic,
        purchaser_dic: @receipt.contact_dic,
        purchaser_street: @receipt.address_street,
        purchaser_street_number: @receipt.address_street_number,
        purchaser_postcode: @receipt.address_postcode,
        purchaser_city: @receipt.address_city,
        purchaser_city_part: @receipt.address_city_part,
        purchaser_extra_address_line: @receipt.address_extra_address_line,
        issue_date: @receipt.issue_date.to_s,
        total: @receipt.amount.to_s,
        bank_account_number: @receipt.account_bank_account_number,
        account_iban: @receipt.account_iban,
        account_swift: @receipt.account_swift,
        items: printable_items
      )
    end

    def printable_items
      printable_items = []
      @receipt.items.each do |item|
        printable_items << InvoicePrinter::Document::Item.new(
          name: item.name,
          quantity: item.number,
          unit: item.unit,
          price: item.price,
          amount: item.amount
        )
      end
      printable_items
    end
  end
end
