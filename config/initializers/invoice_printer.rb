require 'invoice_printer'

InvoicePrinter.labels = {
  # for invoice_printer 0.0.8
  tax_id2: 'DIČ',
  tax_id: 'IČ',
  name: 'Faktura',
  provider: 'Dodavatel',
  provider_tax_id: 'IČ',
  provider_tax_id2: 'DIČ',
  purchaser: 'Odběratel',
  purchaser_tax_id: 'IČ',
  purchaser_tax_id2: 'DIČ',
  payment: 'Forma úhrady',
  payment_in_cash: 'Platba v hotovosti',
  payment_by_transfer: 'Platba na následující účet:',
  account_number: 'Číslo účtu',
  issue_date: 'Datum vydání',
  due_date: 'Datum splatnosti',
  item: 'Položka',
  quantity: 'Počet',
  unit: 'MJ',
  price_per_item: 'Cena za položku',
  amount: 'Cena',
  subtotal: 'Cena bez daně',
  tax: 'DPH 21 %',
  total: 'Celkem'
}
