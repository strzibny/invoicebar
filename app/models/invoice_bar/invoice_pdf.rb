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
        number: @invoice.number,
        provider_name: @invoice.user_name,
        provider_ic: @invoice.user_ic,
        provider_street: @invoice.user_street,
        provider_street_number: @invoice.user_street_number,
        provider_postcode: @invoice.user_postcode,
        provider_city: @invoice.user_city,
        provider_city_part: @invoice.user_city_part,
        provider_extra_address_line: @invoice.user_extra_address_line,
        purchaser_name: @invoice.contact_name,
        purchaser_ic: @invoice.contact_ic,
        purchaser_dic: @invoice.contact_dic,
        purchaser_street: @invoice.address_street,
        purchaser_street_number: @invoice.address_street_number,
        purchaser_postcode: @invoice.address_postcode,
        purchaser_city: @invoice.address_city,
        purchaser_city_part: @invoice.address_city_part,
        purchaser_extra_address_line: @invoice.address_extra_address_line,
        issue_date: @invoice.issue_date.to_s,
        due_date: @invoice.due_date.to_s,
        total: @invoice.amount.to_s,
        bank_account_number: @invoice.account_bank_account_number,
        account_iban: @invoice.account_iban,
        account_swift: @invoice.account_swift,
        items: printable_items
      )
    end

    def printable_items
      printable_items = []
      @invoice.items.each do |item|
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
