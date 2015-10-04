module InvoiceBar
  module Billable
    module Associations
      module StrictValidations
        extend ActiveSupport::Concern

        included do
          accepts_nested_attributes_for :address, allow_destroy: true, reject_if: false
        end
      end
    end
  end
end
