FactoryGirl.define do
  factory :invoice_bar_item, class: InvoiceBar::Item do    
    name 'Item'
    price 1000
    amount { price }  
  end
end