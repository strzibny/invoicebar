module InvoiceBar
  module Billable
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
  end
end
