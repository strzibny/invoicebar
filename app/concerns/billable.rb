module InvoiceBar
  # Module for billing concerns.
  module Billable
  end
end

require File.expand_path('../billable/base.rb',  __FILE__)
require File.expand_path('../billable/filters.rb',  __FILE__)
require File.expand_path('../billable/invoicing.rb',  __FILE__)
require File.expand_path('../billable/receipting.rb',  __FILE__)
require File.expand_path('../billable/strict_validations.rb',  __FILE__)
require File.expand_path('../billable/associations.rb',  __FILE__)
