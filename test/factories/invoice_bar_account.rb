FactoryGirl.define do
  factory :invoice_bar_account, class: InvoiceBar::Account do
    name { generate :invoice_bar_name }
    amount 0

    user { FactoryGirl.create(:invoice_bar_user) }
    currency { FactoryGirl.create(:invoice_bar_currency) }
  end

  factory :invoice_bar_plain_account, class: InvoiceBar::Account do
    name 'Bank Account'
    amount 0

    currency { FactoryGirl.create(:invoice_bar_currency) }
  end
end
