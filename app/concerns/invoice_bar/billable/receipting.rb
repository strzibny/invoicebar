module InvoiceBar
  module Billable
    # Specific features for receipts.
    # It specifies if the receipt is an expense or an income.
    module Receipting
      extend ActiveSupport::Concern

      included do
        class << self
          def expense
            where(issuer: false)
          end

          def income
            where(issuer: true)
          end
        end

        def expense?
          if self.issuer?
            false
          else
            true
          end
        end

        def income?
          !expence?
        end
      end
    end
  end
end
