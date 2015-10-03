system('RAILS_ENV=development rake db:drop')
system('RAILS_ENV=development rake db:create')
system('RAILS_ENV=development rake db:migrate')

require File.expand_path("../../test/dummy/config/environment.rb",  __FILE__)

# Use FactoryGirl definitions
require 'faker'
require 'factory_girl'
FactoryGirl.definition_file_paths = [File.expand_path("../../test/factories",  __FILE__)]
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

accounts = []
10.times {
  accounts << FactoryGirl.create(:invoice_bar_account_with_random_amount, user: administrator)
}

30.times {
  puts FactoryGirl.create(:invoice_bar_invoice, user: administrator, account: accounts.first).inspect
}

3.times {
  puts FactoryGirl.create(:invoice_bar_filled_invoice_template, user: administrator, account: accounts.first).inspect
}

30.times {
  puts FactoryGirl.create(:invoice_bar_receipt, user: administrator, account: accounts.first).inspect
}

3.times {
  puts FactoryGirl.create(:invoice_bar_filled_receipt_template, user: administrator, account: accounts.first).inspect
}
