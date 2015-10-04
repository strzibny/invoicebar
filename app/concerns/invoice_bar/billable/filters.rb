module InvoiceBar
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
      end
    end
  end
end
