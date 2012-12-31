FactoryGirl.define do
  factory :invoice_bar_user, class: InvoiceBar::User do
    name { generate :invoice_bar_name }
    email { Faker::Internet.email }
    ic { generate :invoice_bar_ic }
    
    address { FactoryGirl.build(:invoice_bar_address) }
  end
end