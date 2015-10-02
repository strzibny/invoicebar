# encoding: utf-8

module InvoiceBar
  class InvoiceTemplate < ActiveRecord::Base
    before_validation :update_amount

    attr_accessible :name

    validates :name, presence: true
    validate :name_is_unique

    include InvoiceBar::Billable::Base
    include InvoiceBar::Billable::Invoicing

    include InvoiceBar::Billable::Associations::Base

    # Search
    include InvoiceBar::Searchable

    def self.searchable_fields
      ['name']
    end

    private

      # Validates uniqueness of a name for current user.
      def name_is_unique
        invoice_templates = InvoiceTemplate.where(name: self.name, user_id: self.user_id)

        if invoice_templates.any?
          errors.add(:name, :uniqueness) unless invoice_templates.include? self
        end
      end
  end
end
