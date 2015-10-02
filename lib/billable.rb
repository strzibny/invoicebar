module InvoiceBar
  # Module for billing concerns.
  module Billable

    # Filters for narrowing the results when listing bills
    module Filters
      extend ActiveSupport::Concern

      included do

        # Looks for bills that match +number+
        # and returns a collection of matching bills
        def self.for_numbers(number)
          records = limit(nil)
          records = where('number LIKE ?', "%#{number}%") if number.present?

          records
        end

        # Looks for the date range from +from_date+ to +to_date+ of bills
        # and returns a collection of matching bills
        def self.within_dates(from_date, to_date)
          records = limit(nil)
          records = records.where('issue_date >= ?', from_date) if from_date.present?
          records = records.where('issue_date <= ?', to_date) if to_date.present?

          records
        end

        # Looks for the amount range from +from_amount+ to +to_amount+ of bills
        # and returns a collection of matching bills
        def self.within_amounts(from_amount, to_amount)
          records = limit(nil)
          records = records.where('amount >= ?', from_amount) if from_amount.present?
          records = records.where('amount <= ?', to_amount) if to_amount.present?

          records
        end

        # Looks for the contacts of bills
        # and returns a collection of matching bills
        def self.including_contacts(contact)
          records = limit(nil)
          records = where('contact_name LIKE ?', "%#{contact}%") if contact.present?

          records
        end

        def self.paid(is_paid)
          records = case is_paid
            when true then where('paid = ?', true)
            when false then where('paid = ?', false)
            else limit(nil)
          end

          records
        end

        def self.sent(is_sent)
          records = case is_sent
            when true then where('sent = ?', true)
            when false then where('sent = ?', false)
            else limit(nil)
          end

          records
        end
      end
    end

    # Specific features to invoicing. It specifies +due_date+ and
    # whether the invoice is received or issued.
    module Invoicing
      extend ActiveSupport::Concern

      included do
        attr_accessible :due_date, :payment_identification_number, :issuer
        validates :payment_identification_number, numericality: true, allow_blank: true

        class << self
          def received
            where(issuer: false)
          end

          def issued
            where(issuer: true)
          end
        end

        def received?
          unless self.issuer?
            true
          else
            false
          end
        end

        def issued?
          !received?
        end
      end
    end

    # Specific features for receipts.
    # It specifies if the receipt is an expense or an income.
    module Receipting
      extend ActiveSupport::Concern

      included do
        attr_accessible :issuer

        class << self
          def expense
            where(issuer: false)
          end

          def income
            where(issuer: true)
          end
        end

        def expense?
          unless self.issuer?
            true
          else
            false
          end
        end

        def income?
          !expence?
        end
      end
    end

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
            self.items << item.copy
          end
        end

        # Updates +amount+ from the associated items.
        def update_amount
          self.amount = 0

          self.items.each do |item|
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

          return true
        end
      end
    end

    module StrictValidations
      extend ActiveSupport::Concern

      included do
        validates :issue_date,    presence: true
        validates :account_id,    presence: true
        validates :contact_name,  presence: true
        validates :contact_ic, length: { in:  2..8 }, numericality: true, allow_blank: true
      end
    end

    # Associations for bills.
    module Associations
      module Base
        extend ActiveSupport::Concern

        included do
          attr_accessible :account_id, :user_id,
                          :address, :address_attributes,
                          :items_attributes

          delegate :city, :city_part, :extra_address_line, :postcode, :street, :street_number,
                   :address, :name, :ic,
                   to:  :user, prefix: true

          delegate :city, :city_part, :extra_address_line, :postcode, :street, :street_number,
                   to: :address, prefix: true

          delegate :name, :bank_account_number, :swift, :iban,
                   to: :account, prefix: true

          belongs_to :account
          belongs_to :user

          has_one :address, as: :addressable, dependent: :destroy
          has_many :items, as: :itemable, dependent: :destroy

          accepts_nested_attributes_for :items, allow_destroy: true, reject_if: :all_blank
          accepts_nested_attributes_for :address, allow_destroy: true, reject_if: :all_blank

          validates :user_id, presence: true, numericality: true
        end
      end

      module StrictValidations
        extend ActiveSupport::Concern

        included do
          accepts_nested_attributes_for :address, allow_destroy: true, reject_if: false
        end
      end
    end
  end
end
