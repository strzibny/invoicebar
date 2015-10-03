FactoryGirl.define do
  factory :invoice_bar_invoice_template, class: InvoiceBar::InvoiceTemplate do
    name { generate :invoice_bar_invoice_template_name }

    user { FactoryGirl.create(:invoice_bar_user) }
    account { FactoryGirl.create(:invoice_bar_account) }
  end

  factory :invoice_bar_filled_invoice_template, class: InvoiceBar::InvoiceTemplate do
    name { generate :invoice_bar_invoice_template_name }
    issue_date { Date.yesterday }
    due_date { issue_date + 28.days }
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
