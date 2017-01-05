module InvoiceBar
  module Billable
    # Specific features to invoicing. It specifies +due_date+ and
    # whether the invoice is received or issued.
    module Invoicing
      extend ActiveSupport::Concern

      included do
        validates :payment_identification_number, numericality: true, allow_blank: true

        class << self
          def received
            basic.where(issuer: false)
          end

          def issued
            basic.where(issuer: true)
          end

          def received_deposit
            deposit.where(issuer: false)
          end

          def issued_deposit
            deposit.where(issuer: true)
          end
        end

        def received?
          if self.issuer?
            false
          else
            true
          end
        end

        def issued?
          !received?
        end
      end
    end
  end
end
