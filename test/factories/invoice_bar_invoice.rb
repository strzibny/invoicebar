FactoryGirl.define do
  factory :invoice_bar_invoice, class: InvoiceBar::Invoice do
    number { generate :invoice_bar_invoice_number }
    issue_date { Date.today }
    due_date { issue_date + 14.days }
    user_name 'Me'
    user_ic 102940
    contact_name 'Company'
    contact_ic 102939
    user_address { FactoryGirl.build(:invoice_bar_address, addressable_type: 'InvoiceBar::Invoice#user_address' ) }
    address { FactoryGirl.build(:invoice_bar_address, addressable_type: 'InvoiceBar::Invoice#contact_address') }
    amount 1000000

    user { FactoryGirl.create(:invoice_bar_user) }
    account { FactoryGirl.create(:invoice_bar_account, user: user) }
    items { [FactoryGirl.build(:invoice_bar_item)] }
  end

  factory :invoice_bar_incomplete_invoice, class: InvoiceBar::Invoice do
    number { generate :invoice_bar_invoice_number }
    user_name 'Me'
    user_ic 102940
    contact_name 'Company'
    contact_ic 102939
    contact_dic 'CZ21'
    user_address { FactoryGirl.build(:invoice_bar_address, addressable_type: 'InvoiceBar::Invoice#user_address' ) }
    address { FactoryGirl.build(:invoice_bar_address, addressable_type: 'InvoiceBar::Invoice#contact_address') }
    amount 1000000

    user { FactoryGirl.create(:invoice_bar_user) }
    account { FactoryGirl.create(:invoice_bar_account) }
    items { [FactoryGirl.build(:invoice_bar_item)] }
  end
end
