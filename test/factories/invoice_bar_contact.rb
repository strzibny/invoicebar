FactoryGirl.define do  
  factory :invoice_bar_contact, class: InvoiceBar::Contact do
    name 'Person'
    
    user { FactoryGirl.create(:invoice_bar_user) }
  end
end