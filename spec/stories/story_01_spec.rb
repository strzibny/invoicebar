# Register user
# Sign in
# Start invoicing from a given invoice number
# Invoice through out the year

require 'spec_helper'

RSpec.feature 'User story 1' do
  scenario 'story 1' do
    travel_to Time.new(2016, 01, 02, 1, 04, 44)

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

    # TODO: count by year/month/day
    fill_in t('attributes.user.preferences.issued_invoice_sequence'), with: 'VF%Y%m'
    fill_in t('attributes.user.preferences.last_issued_invoice'), with: 'VF2015120010'
    click_button t('buttons.save')

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
    create_invoice contact: client_a,
                   account_name: 'Account 2',
                   issue_date: '2016-01-02',
                   due_date: '2016-01-15',
                   note: 'Podnikatel je zapsán do živnostenského rejstříku',
                   items: [
                    build(:invoice_bar_item)
                   ]

    expect(page).to have_content('VF2016010001')
    #click_button t('buttons.create')

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
    build(:invoice_bar_contact, name: 'Client A, s.r.o.', address: build(:invoice_bar_address))
  end

  def client_b
    build(:invoice_bar_contact, name: 'Client B, a.s.', address: build(:invoice_bar_address))
  end

  def client_c
    build(:invoice_bar_contact, name: 'Client C', address: build(:invoice_bar_address))
  end

  def create_invoice(contact:,
                     account_name:,
                     issue_date:,
                     due_date:,
                     note:,
                     items:)
    click_link t('invoice_bar.navbar.invoices')
    click_link t('links.new_invoice')
    fill_in t('attributes.invoice.contact_name'), with: contact.name
    fill_in t('attributes.invoice.contact_tax_id'), with: contact.tax_id
    fill_in t('attributes.invoice.contact_tax_id2'), with: contact.tax_id2
    fill_in t('attributes.address.street'), with: contact.street
    fill_in t('attributes.address.street_number'), with: contact.street_number
    fill_in t('attributes.address.postcode'), with: contact.postcode
    fill_in t('attributes.address.city'), with: contact.city
    fill_in t('attributes.address.city_part'), with: contact.city_part
    fill_in t('attributes.address.extra_address_line'), with: contact.extra_address_line

    select account_name, from: t('attributes.invoice.account_id')
    fill_in t('attributes.invoice.issue_date'), with: issue_date
    fill_in t('attributes.invoice.due_date'), with: due_date
    fill_in t('attributes.invoice.note'), with: note

    items.each do |item|
      fill_in t('attributes.item.name'), with: item.name
      fill_in t('attributes.item.number'), with: item.number
      fill_in t('attributes.item.unit'), with: item.unit
      fill_in t('attributes.item.price'), with: item.price
    end
    click_button t('buttons.save')
  end
end
