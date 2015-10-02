require File.expand_path("../../config/environment.rb",  __FILE__)

# Use FactoryGirl definitions
require 'faker'
require 'factory_girl'
FactoryGirl.definition_file_paths = [File.expand_path("../../../factories",  __FILE__)]
FactoryGirl.find_definitions

currencies = InvoiceBar::Currency.create([
  { name: 'Česká koruna', symbol: 'Kč', priority: '4' },
  { name: 'Euro', symbol: '€', priority: '3' },
  { name: 'Americký dolar', symbol: 'US$', priority: '2' },
  { name: 'Polský zlotý', symbol: 'zł', priority: '1' }
])

# Create administrator
administrator = InvoiceBar::User.create!(
  name: 'admin',
  email: 'admin@admin.cz',
  ic: 123456,
  administrator: true,
  #address: address
)

address = InvoiceBar::Address.create(
  street: 'Ulice',
  street_number: '1',
  city: 'Mesto',
  postcode: '74727',
  addressable_id: administrator.id,
  addressable_type: 'User'
)

10.times {
  administrator.accounts << FactoryGirl.create(:invoice_bar_account_with_random_amount, user: administrator)
}

30.times {
  administrator.invoices << FactoryGirl.create(:invoice_bar_invoice, user: administrator)
}

3.times {
  administrator.invoices << FactoryGirl.create(:invoice_bar_filled_invoice_template, user: administrator)
}

30.times {
  administrator.invoices << FactoryGirl.create(:invoice_bar_receipt, user: administrator)
}

3.times {
  administrator.invoices << FactoryGirl.create(:invoice_bar_filled_receipt_template, user: administrator)
}

administrator.save