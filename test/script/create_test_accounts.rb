#!/usr/bin/env ruby
# Import basic test data for running and browsing the application
# during development.
ENV['RAILS_ENV'] ||= 'development'

require File.expand_path('../../dummy/config/environment.rb',  __FILE__)

FactoryGirl.definition_file_paths = [
  File.expand_path('../../../test/factories',  __FILE__)
]
FactoryGirl.find_definitions

InvoiceBar::Currency.delete_all
InvoiceBar::User.delete_all
InvoiceBar::Account.delete_all

# Create testing user with an account
currency = FactoryGirl.create(
  :invoice_bar_currency,
  name: 'Euro',
  symbol: '€',
  priority: 0
)

user = FactoryGirl.create(
  :invoice_bar_user,
  email: 'test@test.cz',
  password: 'test'
)

account = FactoryGirl.create(
  :invoice_bar_account,
  user: user,
  currency: currency
)
