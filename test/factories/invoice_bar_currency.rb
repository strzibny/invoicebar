FactoryGirl.define do
  factory :invoice_bar_currency, class: InvoiceBar::Currency do
    name { generate :invoice_bar_currency_name }
    symbol { generate :invoice_bar_currency_symbol }
    priority 0
  end
end