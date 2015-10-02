# Use FactoryGirl definitions
require 'faker'
require 'factory_girl'
FactoryGirl.find_definitions

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create the list of most used currencies
currencies = InvoiceBar::Currency.create([
  { name: 'Česká koruna', symbol: 'Kč', priority: '4' },
  { name: 'Euro', symbol: '€', priority: '3' },
  { name: 'Americký dolar', symbol: 'US$', priority: '2' },
  { name: 'Polský zlotý', symbol: 'zł', priority: '1' }
])

# Create administrator
administrator = InvoiceBar::User.create(
  name: 'admin',
  email: 'admin@admin.cz',
  ic: 123456,
  administrator: true,
  address: InvoiceBar::Address.create(
    street: 'Ulice',
    street_number: '1',
    city: 'Mesto',
    postcode: '74727'
  )
)

10.times {
  administrator.accounts << FactoryGirl.create(:invoice_bar_account_with_random_amount)
}

30.times {
  administrator.invoices << FactoryGirl.create(:invoice_bar_invoice)
}

3.times {
  administrator.invoices << FactoryGirl.create(:invoice_bar_filled_invoice_template)
}

30.times {
  administrator.invoices << FactoryGirl.create(:invoice_bar_receipt)
}

3.times {
  administrator.invoices << FactoryGirl.create(:invoice_bar_filled_receipt_template)
}

administrator.save
