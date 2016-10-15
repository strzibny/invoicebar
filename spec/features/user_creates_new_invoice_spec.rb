require 'spec_helper'

feature 'User creates new invoice' do
  include_context 'Signed-in user'

  scenario 'with valid inputs' do
    visit '/invoices'

    click_link 'Nová faktura'

    #expect(page).to have_content('')
  end
end
