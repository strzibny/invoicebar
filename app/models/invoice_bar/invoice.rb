# encoding: utf-8

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
      ['number', 'contact_name', 'contact_ic']
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
        invoices = Invoice.where(:number => self.number, :user_id => self.user_id)

        if invoices.any?
          errors.add(:number, :uniqueness) unless invoices.include? self
        end
      end
  end
end
