InvoiceBar::Engine.routes.draw do
  # Sessions
  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'login' => 'sessions#new', :as => 'login'
  get 'login_from_http_basic' => 'sessions#login_from_http_basic', :as => 'login_from_http_basic'

  resources :sessions

  # Search
  get 'search' => 'search#index', :as => 'search'

  # Users
  get 'signup' => 'users#new', :as => 'signup'
  get 'profile' => 'settings#index', :as => 'profile'

  resources :users

  # Contacts
  resources :contacts

  # Currencies
  resources :currencies

  # Accounts
  resources :accounts

  # Invoices
  get 'invoices/from_template/:id' => 'invoices#from_template', :as => 'invoice_from_template'
  get 'invoices/:id/mark_as_paid' => 'invoices#mark_as_paid', :as => 'mark_invoice_as_paid'
  get 'invoices/:id/mark_as_sent' => 'invoices#mark_as_sent', :as => 'mark_invoice_as_sent'
  get 'invoices/:id/create_receipt_for_invoice' => 'invoices#create_receipt_for_invoice', :as => 'create_receipt_for_invoice'
  get 'invoices/filter' => 'invoices#filter', :as => 'filter_invoices', method: :get
  get 'invoices/issued' => 'invoices#issued', :as => 'issued_invoices', method: :get
  get 'invoices/received' => 'invoices#received', :as => 'received_invoices', method: :get

  resources :invoices
  resources :invoice_templates

  # Receipts
  get 'receipts/from_template/:id' => 'receipts#from_template', :as => 'receipt_from_template'
  get 'receipts/filter' => 'receipts#filter', :as => 'filter_receipts', method: :get
  get 'receipts/income' => 'receipts#income', :as => 'income_receipts', method: :get
  get 'receipts/expence' => 'receipts#expence', :as => 'expence_receipts', method: :get

  resources :receipts
  resources :receipt_templates

  # Root default
  root :to => 'dashboard#index'
end
