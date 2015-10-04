module InvoiceBar
  # Module for billing concerns.
  module Billable
    # Common things for both invoices and receipts.
    module Base
      extend ActiveSupport::Concern

      included do
        attr_accessible :amount, :contact_dic, :contact_ic, :contact_name, :issue_date, :issuer

        validates :contact_ic,  length: { in:  2..8 },  numericality: true, allow_blank: true
        validates :contact_dic, length: { in:  4..14 }, allow_blank: true

        # Generates a new bill from a given +template+.
        def self.from_template(template)
          bill = self.new
          bill.apply_template(template)

          bill.address ||= invoice.build_address
          bill.issue_date = Date.today if bill.issue_date.blank?

          if self.respond_to? :due_date
            bill.due_date = Date.today + 14.days if bill.due_date.blank?
          end

          bill
        end

        # Applies values from the given +template+ to the bill.
        def apply_template(template)
          attributes = ['contact_name', 'contact_ic', 'contact_dic', 'issue_date']

          if self.respond_to? :due_date
            attributes << 'due_date'
          end

          if self.respond_to? :payment_identification_number
            attributes << 'payment_identification_number'
          end

          attributes.each do |attribute|
            eval "self.#{attribute} = nil if self.#{attribute}.blank?"
          end

          self.contact_name ||= template.contact_name unless template.contact_name.blank?
          self.contact_ic ||= template.contact_ic unless template.contact_ic.blank?
          self.contact_dic ||= template.contact_dic unless template.contact_dic.blank?

          if self.respond_to? :due_date
            self.due_date ||= template.due_date unless template.due_date.blank?
          end

          self.issue_date ||= template.issue_date unless template.issue_date.blank?

          if self.respond_to? :payment_identification_number
            self.payment_identification_number ||= template.payment_identification_number unless template.payment_identification_number.blank?
          end

          self.address ||= Address.new

          if self.address.empty?
            self.address = template.address.copy unless template.address.nil?
          end

          template.items.each do |item|
            items << item.copy
          end
        end

        # Updates +amount+ from the associated items.
        def update_amount
          self.amount = 0

          items.each do |item|
            item.update_amount
            self.amount += item.amount unless item.amount.nil?
          end
        end

        # Import and overwrites values from the given +contact+
        def use_contact(contact)
          self.contact_name = contact.name
          self.contact_ic = contact.ic
          self.contact_dic = contact.dic
          self.address = Address.new unless self.address
          self.address.postcode = contact.postcode
          self.address.city = contact.city
          self.address.city_part = contact.city_part
          self.address.street = contact.street
          self.address.street_number = contact.street_number
          self.address.extra_address_line = contact.extra_address_line
        end

        # Import and overwrites values from the ARES subject.
        # Returns true on success and false on failure.
        def load_contact_from_ic(ic)
          begin
            contact = RubyARES::Subject.get(ic)
          rescue
            return false
          end

          self.contact_name = contact.name
          self.contact_ic = contact.ic
          self.contact_dic = contact.dic
          self.address = Address.new unless self.address
          self.address.city = contact.address.city
          self.address.city_part = contact.address.city_part unless contact.address.city == contact.address.city_part
          self.address.street = contact.address.street
          self.address.street_number = contact.address.street_number
          self.address.postcode = contact.address.postcode

          true
        end
      end
    end
  end
end
