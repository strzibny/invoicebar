# encoding: utf-8

module InvoiceBar
  class Receipt < ActiveRecord::Base
    before_validation :update_amount

    attr_accessible :number, :sent, :paid

    validates :number, presence: true
    validate :number_is_unique

    include InvoiceBar::Billable::Base
    include InvoiceBar::Billable::StrictValidations
    include InvoiceBar::Billable::Receipting

    include InvoiceBar::Billable::Associations::Base
    include InvoiceBar::Billable::Associations::StrictValidations

    has_one :invoice

    include InvoiceBar::Billable::Filters

    # Search
    include InvoiceBar::Searchable

    def self.searchable_fields
      ['number', 'contact_name', 'contact_ic']
    end

    def self.for_invoice(invoice)
      receipt = Receipt.new
      receipt.contact_name = invoice.contact_name
      receipt.contact_ic = invoice.contact_ic
      receipt.contact_dic = invoice.contact_dic
      receipt.account_id = invoice.account_id
      receipt.issue_date = Date.today

      receipt.address = invoice.address.copy

      invoice.items.each do |item|
        receipt.items << item.copy
      end

      receipt
    end

    def mark_as_paid
      self.paid = true
    end

    def mark_as_sent
      self.sent = true
    end

    private

      # Validates uniqueness of a number for current user.
      def number_is_unique
        invoices = Receipt.where(:number => self.number, :user_id => self.user_id)

        if invoices.any?
          errors.add(:number, :uniqueness) unless invoices.include? self
        end
      end
  end
end
