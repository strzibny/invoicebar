# InvoiceBar

Rails Engine/RubyGem for single-entry accounting. Currently only in Czech for the Czech Legislation.
It's a mountable Engine, so you don't have to worry about namespace issues.

## Installation


Specify the dependency:
```ruby
# Gemfile
gem 'invoice_bar'
```
And load the Engine at a specific path:
```ruby
# config/routes.rb
mount InvoiceBar::Engine => "/"
```

## Usage

First created user is an administrator, who should create list of currencies. Then you can create accounts under "Nastavení/Účty" (at `invoice_bar/accounts`) and start invoicing. If the invoice is marked as paid, the corresponding receipt will be created.

## Features

* Invoicing -- issued and received invoices 
* Tracking of sent/not sent/paid/unpaid invoices
* Accounting -- income and expence receipts (created from invoices by a single click)
* Contacts -- address book with autofilling when creating bills
* Invoice and receipt templates
* Loading contact information by IČ from ARES database when creating bills
* Search