FactoryGirl.define do
  sequence(:invoice_bar_name) { |n| "Name #{n}" }
  sequence(:invoice_bar_email) { |n| "#{n}abc9@email.cz" }
  sequence(:invoice_bar_ic) { |n| "#{n}78974" }
  sequence(:invoice_bar_amount) { |n| "#{n}" }
  sequence(:invoice_bar_invoice_number) { |n| "20100112#{n}" }
  sequence(:invoice_bar_currency_name) { |n| "kc#{n}" }
  sequence(:invoice_bar_currency_symbol) { |n| "k#{n}" }
  sequence(:invoice_bar_account_name) { |n| "Name #{n}" }
  sequence(:invoice_bar_invoice_template_name) { |n| "Name #{n}" }
  sequence(:invoice_bar_receipt_template_name) { |n| "Name #{n}" }
end
