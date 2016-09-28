FactoryGirl.define do
  factory :invoice_bar_user, class: User do
    name { generate :invoice_bar_name }
    email { Faker::Internet.email }
    tax_id { generate :invoice_bar_tax_id }
    password { }

    address { FactoryGirl.build(:invoice_bar_address) }
  end
end
