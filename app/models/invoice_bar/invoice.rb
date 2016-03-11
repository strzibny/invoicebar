module InvoiceBar
  class Invoice < ActiveRecord::Base
    before_validation :update_amount

    attr_accessible :number, :sent, :paid

    validates :number, presence: true
    validate :number_is_unique

    validates :due_date, presence: true

    include InvoiceBar::Billable::Base
    include InvoiceBar::Billable::StrictValidations
    include InvoiceBar::Billable::Invoicing

    include InvoiceBar::Billable::Associations::Base
    include InvoiceBar::Billable::Associations::StrictValidations

    belongs_to :receipt

    include InvoiceBar::Billable::Filters

    # Search
    include InvoiceBar::Searchable

    def self.searchable_fields
      %w( number contact_name contact_ic )
    end

    def mark_as_paid
      self.paid = true
    end

    def mark_as_sent
      self.sent = true
    end

    def to_pdf
      require 'invoice_printer'
      printable_items = []

      items.each do |item|
        printable_items << InvoicePrinter::Document::Item.new(
          name: item.name,
          quantity: item.number,
          unit: item.unit,
          price: item.price,
          amount: item.amount
        )
      end

      invoice = InvoicePrinter::Document.new(
        number: number,
        provider_name: user_name,
        provider_ic: user_ic,
        provider_street: user_street,
        provider_street_number: user_street_number,
        provider_postcode: user_postcode,
        provider_city: user_city,
        provider_city_part: user_city_part,
        provider_extra_address_line: user_extra_address_line,
        purchaser_name: contact_name,
        purchaser_ic: contact_ic,
        purchaser_dic: contact_dic,
        purchaser_street: address_street,
        purchaser_street_number: address_street_number,
        purchaser_postcode: address_postcode,
        purchaser_city: address_city,
        purchaser_city_part: address_city_part,
        purchaser_extra_address_line: address_extra_address_line,
        issue_date: issue_date.to_s,
        due_date: due_date.to_s,
        total: amount.to_s,
        bank_account_number: account_bank_account_number,
        account_iban: account_iban,
        account_swift: account_swift,
        items: printable_items
      )

      render = InvoicePrinter.render(
        document: invoice
      )
    end

    private

      # Validates uniqueness of a number for current user.
      def number_is_unique
        invoices = Invoice.where(number: number, user_id: user_id)

        if invoices.any? && !invoices.include?(self)
          errors.add(:number, :uniqueness)
        end
      end
  end
end
