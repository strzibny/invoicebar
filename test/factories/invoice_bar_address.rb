FactoryGirl.define do
  factory :invoice_bar_address, class: InvoiceBar::Address do
    city 'City'
    city_part 'Part'
    postcode '45695'
    street 'Street'
    street_number '28a'
    extra_address_line ''
    addressable_type nil
  end
end
