# Register user
# Sign in
# Start invoicing from a given invoice number
# Invoice through out the year

require 'spec_helper'

RSpec.feature 'User story 1' do
  scenario 'story 1' do
    # Set up currencies
    create(:invoice_bar_currency, name: 'CZK', symbol: 'Kc')
    create(:invoice_bar_currency, name: 'EUR', symbol: 'E')

    user = build(:invoice_bar_user,
      email: 'user@google.com',
      password: '123456781'
    )

    # Registration
    register login: user.email,
             password: user.password,
             name: user.name,
             tax_id: user.tax_id,
             street: user.street,
             street_number: user.street_number,
             postcode: user.postcode,
             city: user.city,
             city_part: user.city_part,
             extra_address_line: user.extra_address_line

    expect(page).to have_content(t('messages.signed_up'))

    # Log in
    sign_in login: user.email, password: user.password

    # Setting the last invoice number
    click_link t('invoice_bar.navbar.settings')
    click_link t('navigation.sequences_settings')
    fill_in t('attributes.user.preferences.issued_invoice_sequence'), with: 'VF%Y%m'
    fill_in t('attributes.user.preferences.last_issued_invoice'), with: 'VF201512050010'

    # Set up bank accounts
    create_account name: 'Account 1',
                   bank_account_number: '123456987/0100',
                   iban: '',
                   swift: '',
                   currency: 'EUR',
                   amount: '1500'

    create_account name: 'Account 2',
                   bank_account_number: '123456989/0100',
                   iban: '',
                   swift: '',
                   currency: 'CZK',
                   amount: '118000'


    # Generating first January invoice

    expect(page).to have_content('VF201601020001')
    click_button t('buttons.save')

    # Log out
    sign_out
  end

  private

  def create_account(name:,
                     bank_account_number:,
                     iban:,
                     swift:,
                     currency:,
                     amount:)
    #click_link t('invoice_bar.navbar.settings')
    click_link t('invoice_bar.navbar.accounts')
    click_link t('titles.accounts.new')
    fill_in t('attributes.account.name'), with: name
    fill_in t('attributes.account.bank_account_number'), with: bank_account_number
    fill_in t('attributes.account.iban'), with: iban
    fill_in t('attributes.account.swift'), with: swift
    select currency, from: t('attributes.account.currency_id')
    fill_in t('attributes.account.amount'), with: amount
    click_button t('buttons.save')
  end

  def client_a
    build(:invoice_bar_contact, name: 'Client A, s.r.o.')
  end

  def client_b
    build(:invoice_bar_contact, name: 'Client B, a.s.')
  end

  def client_c
    build(:invoice_bar_contact, name: 'Client C')
  end
end
