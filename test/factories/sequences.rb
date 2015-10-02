FactoryGirl.define do
  sequence(:invoice_bar_name) { |n| "Name #{hash[n]}9" }
  sequence(:invoice_bar_email) { |n| "#{hash[n]}#{n}#{n}abc9@email.cz" }
  sequence(:invoice_bar_ic) { |n| "#{n}78974" }
  sequence(:invoice_bar_amount) { |n| "#{n}" }
  sequence(:invoice_bar_invoice_number) { |n| "20100112#{n}" }
  sequence(:invoice_bar_currency_name) { |n| "kc#{n}" }
  sequence(:invoice_bar_currency_symbol) { |n| "k#{n}" }
end
