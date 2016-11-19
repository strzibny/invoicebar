require 'spec_helper'

feature 'User creates new invoice' do
  include_context 'Signed-in user'

  scenario 'with valid inputs' do
    invoice = build(:invoice_bar_invoice)

    visit '/invoices'

    click_link 'Nová faktura'

    fill_in t('attributes.invoice.contact_name'), with: invoice.contact_name
    fill_in t('attributes.invoice.contact_tax_id'), with: invoice.contact_tax_id
    fill_in t('attributes.address.street'), with: invoice.contact_street
    fill_in t('attributes.address.street_number'), with: invoice.contact_street_number
    fill_in t('attributes.address.city'), with: invoice.contact_city
    fill_in t('attributes.address.postcode'), with: invoice.contact_postcode



    #expect(page).to have_content('')
  end
end
