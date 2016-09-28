#!/usr/bin/env ruby
# Import basic test data for running and browsing the application
# during development.
ENV['RAILS_ENV'] ||= 'development'

require File.expand_path('../../../config/environment.rb',  __FILE__)

Currency.delete_all
User.delete_all
Account.delete_all

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

25.times do
  FactoryGirl.create(
    :invoice_bar_invoice,
    user: user,
    account: account
  )
end
