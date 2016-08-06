require 'invoice_printer'

InvoicePrinter.labels = {
  name: 'Faktura',
  provider: 'Dodavatel',
  purchaser: 'Odběratel',
  ic: 'IČ',
  dic: 'DIČ',
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
