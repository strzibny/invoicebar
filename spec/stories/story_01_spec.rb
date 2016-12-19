# Register user
# Sign in
# Start invoicing from a given invoice number
# Invoice through out the year

require 'spec_helper'

RSpec.feature 'User story 1', js: true do
  scenario 'story 1' do
    # Janurary 2016
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
    fill_in t('attributes.user.preferences.issued_deposit_invoice_sequence'), with: 'VZF%Y%m'
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
                     build(:invoice_bar_item, unit: 'hod', number: '20', price: '200')
                   ]

    expect(page).to have_content('VF2016010001')

    # February 2016
    travel_to Time.new(2016, 02, 05, 1, 04, 44)

    create_invoice contact: client_a,
                   account_name: 'Account 1',
                   issue_date: '2016-02-05',
                   due_date: '2016-02-27',
                   note: 'Podnikatel je zapsán do živnostenského rejstříku',
                   items: [
                     build(:invoice_bar_item, unit: 'hod', number: '3', price: '150')
                   ]
    expect(page).to have_content('VF2016020001')

    create_invoice contact: client_b,
                   account_name: 'Account 1',
                   issue_date: '2016-02-05',
                   due_date: '2016-02-27',
                   note: 'Podnikatel je zapsán do živnostenského rejstříku',
                   items: [
                     build(:invoice_bar_item, unit: 'hod', number: '4', price: '200')
                   ]
    expect(page).to have_content('VF2016020002')

    # Create deposit invoice, others should start numbering from this one
    # TODO: links to create deposit invoice
    create_deposit_invoice(
      number: 'VZF2016020001',
      contact: client_a,
      account_name: 'Account 2',
      issue_date: '2016-02-05',
      due_date: '2016-02-18',
      note: 'Podnikatel je zapsán do živnostenského rejstříku',
      items: [
       build(:invoice_bar_item, price: '8000')
      ]
    )
    expect(page).to have_content('VZF2016020001')

    # March 2016
    travel_to Time.new(2016, 03, 04, 1, 04, 44)

    # Another deposit for another client
    create_deposit_invoice(
      contact: client_b,
      account_name: 'Account 1',
      issue_date: '2016-03-14',
      due_date: '2016-03-29',
      note: 'Podnikatel je zapsán do živnostenského rejstříku',
      items: [
        build(:invoice_bar_item, price: '400')
      ]
    )
    expect(page).to have_content('VZF2016030001')

    # Final invoices referencing deposits
    create_invoice(
      contact: client_a,
      account_name: 'Account 2',
      issue_date: '2016-03-14',
      due_date: '2016-03-30',
      note: 'Podnikatel je zapsán do živnostenského rejstříku',
      items: [
        build(:invoice_bar_item, unit: 'hod', number: '45', price: '500'),
      ],
      deposit: 'VZF2016020001'
    )

    create_invoice(
      contact: client_b,
      account_name: 'Account 1',
      issue_date: '2016-03-14',
      due_date: '2016-03-30',
      note: 'Podnikatel je zapsán do živnostenského rejstříku',
      items: [
        build(:invoice_bar_item, unit: 'hod', number: '35', price: '50'),
      ],
      deposit: 'VZF2016030001'
    )

    # Create invoice templates

    # 11 invoices in one month



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

  def create_invoice(number: nil,
                     contact:,
                     account_name:,
                     issue_date:,
                     due_date:,
                     note:,
                     items:,
                     deposit: nil)
    click_link t('invoice_bar.navbar.invoices')
    click_link t('links.new_invoice')
    fillin_invoice(
      number: number,
      contact: contact,
      account_name: account_name,
      issue_date: issue_date,
      due_date: due_date,
      note: note,
      items: items,
      deposit: deposit
    )
    click_button t('buttons.save')
  end

  def create_deposit_invoice(number: nil,
                             contact:,
                             account_name:,
                             issue_date:,
                             due_date:,
                             note:,
                             items:)
    #click_link t('invoice_bar.navbar.invoices')
    #click_link t('links.new_invoice')
    #click_link t('titles.deposits')
    visit '/invoices/new_deposit'
    fillin_invoice(
      number: number,
      contact: contact,
      account_name: account_name,
      issue_date: issue_date,
      due_date: due_date,
      note: note,
      items: items
    )
    click_button t('buttons.save')
  end

  def fillin_invoice(number:,
                     contact:,
                     account_name:,
                     issue_date:,
                     due_date:,
                     note:,
                     items:,
                     deposit: nil)

    fill_in t('attributes.invoice.number'), with: number if number
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

    if deposit
      click_link 'Zálohová faktura'
      select deposit, from: t('attributes.item.deposit_invoice')
    end
  end
end
