module InvoiceBar
  module Billable
    # Filters for narrowing the results when listing bills
    module Filters
      extend ActiveSupport::Concern

      included do
        # Looks for bills that match +number+ and returns a collection of
        # matching bills
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

        # Looks for the contacts of bills and returns a collection of
        # matching bills
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
  end
end
