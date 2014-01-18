FactoryGirl.define do
  factory :invoice_bar_receipt_template, class: InvoiceBar::ReceiptTemplate do
    name { generate :invoice_bar_name }

    user { FactoryGirl.create(:invoice_bar_user) }
    account { FactoryGirl.create(:invoice_bar_account) }
  end

  factory :invoice_bar_filled_receipt_template, class: InvoiceBar::ReceiptTemplate do
    issue_date { Date.yesterday }
    contact_name 'Company'
    contact_ic 1029392
    contact_dic 'CZ898989'
    address { FactoryGirl.build(:invoice_bar_address) }
    amount 1000000

    user { FactoryGirl.create(:invoice_bar_user) }
    account { FactoryGirl.create(:invoice_bar_account) }
    items { [FactoryGirl.build(:invoice_bar_item)] }
  end
end
