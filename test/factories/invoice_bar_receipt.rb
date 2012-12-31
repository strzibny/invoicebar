FactoryGirl.define do
  factory :invoice_bar_receipt, class: InvoiceBar::Receipt do
    number { generate :invoice_bar_invoice_number }
    issue_date { Date.today }
    contact_name 'Company'
    contact_ic 102939
    address { FactoryGirl.build(:invoice_bar_address) }
    amount 1000000

    user { FactoryGirl.create(:invoice_bar_user) }
    account { FactoryGirl.create(:invoice_bar_account) }
    items { [FactoryGirl.build(:invoice_bar_item)] }
  end
  
  factory :invoice_bar_incomplete_receipt, class: InvoiceBar::Receipt do
    number { generate :invoice_bar_invoice_number }
    contact_name 'Company'
    contact_ic 102939
    contact_dic 'CZ21'
    address { FactoryGirl.build(:invoice_bar_address) }
    amount 1000000

    user { FactoryGirl.create(:invoice_bar_user) }
    account { FactoryGirl.create(:invoice_bar_account) }
    items { [FactoryGirl.build(:invoice_bar_item)] }
  end
end