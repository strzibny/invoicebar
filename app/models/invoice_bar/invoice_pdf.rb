require 'invoice_printer'

module InvoiceBar
  class InvoicePDF
    def initialize(invoice)
      @invoice = invoice
    end

    def render
      InvoicePrinter.render(document: printable_invoice)
    end

    private

    def printable_invoice
      InvoicePrinter::Document.new(
        number: @invoice.number.to_s,
        provider_name: @invoice.user_name.to_s,
        provider_ic: @invoice.user_ic.to_s,
        provider_street: @invoice.user_street.to_s,
        provider_street_number: @invoice.user_street_number.to_s,
        provider_postcode: @invoice.user_postcode.to_s,
        provider_city: @invoice.user_city.to_s,
        provider_city_part: @invoice.user_city_part.to_s,
        provider_extra_address_line: @invoice.user_extra_address_line.to_s,
        purchaser_name: @invoice.contact_name.to_s,
        purchaser_ic: @invoice.contact_ic.to_s,
        purchaser_dic: @invoice.contact_dic.to_s,
        purchaser_street: @invoice.address_street.to_s,
        purchaser_street_number: @invoice.address_street_number.to_s,
        purchaser_postcode: @invoice.address_postcode.to_s,
        purchaser_city: @invoice.address_city.to_s,
        purchaser_city_part: @invoice.address_city_part.to_s,
        purchaser_extra_address_line: @invoice.address_extra_address_line.to_s,
        issue_date: @invoice.issue_date.to_s,
        due_date: @invoice.due_date.to_s,
        total: @invoice.amount.to_s,
        bank_account_number: @invoice.account_bank_account_number.to_s,
        account_iban: @invoice.account_iban.to_s,
        account_swift: @invoice.account_swift.to_s,
        items: printable_items
      )
    end

    def printable_items
      printable_items = []
      @invoice.items.each do |item|
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
