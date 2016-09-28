FactoryGirl.define do
  factory :invoice_bar_account, class: Account do
    name { generate :invoice_bar_account_name }
    amount 0

    user { FactoryGirl.create(:invoice_bar_user) }
    currency { FactoryGirl.create(:invoice_bar_currency) }
  end

  factory :invoice_bar_plain_account, class: Account do
    name { generate :invoice_bar_account_name }
    amount 0

    currency { FactoryGirl.create(:invoice_bar_currency) }
  end

  factory :invoice_bar_account_with_random_amount, class: Account do
    name { generate :invoice_bar_account_name }
    amount { rand(50_000) }

    currency { FactoryGirl.create(:invoice_bar_currency) }
  end
end
