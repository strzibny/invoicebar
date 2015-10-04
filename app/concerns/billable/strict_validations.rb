module InvoiceBar
  # Module for billing concerns.
  module Billable
    module StrictValidations
      extend ActiveSupport::Concern

      included do
        validates :issue_date,    presence: true
        validates :account_id,    presence: true
        validates :contact_name,  presence: true
        validates :contact_ic, length: { in:  2..8 }, numericality: true, allow_blank: true
      end
    end
  end
end
